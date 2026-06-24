#!/usr/bin/env bash
# Rebuild tmux sessions from a snapshot written by save-sessions.sh.
#
# Restores: sessions, windows (names + order), pane counts, per-pane working
# directories, the saved split layout, and which window/pane was active.
# Does NOT restore: the programs that were running (you get fresh shells).
#
# Existing live sessions are left untouched, so this is safe to run to bring
# back only the sessions you have since closed.
set -euo pipefail

f="$HOME/.tmux/resurrect/last.txt"
[ -f "$f" ] || { tmux display-message "tmux: no saved state ($f)"; exit 0; }

# Session names in the order they first appear.
sessions=$(awk -F'\t' '$1=="w"{print $2}' "$f" | awk '!seen[$0]++')

while IFS= read -r sess; do
  [ -n "$sess" ] || continue
  tmux has-session -t="$sess" 2>/dev/null && continue   # don't clobber a live session

  active_window=""
  first=1

  # Windows for this session, ordered by window index.
  while IFS=$'\t' read -r widx wactive layout wname; do
    [ -n "$widx" ] || continue

    # Pane working dirs for this window, ordered by pane index.
    mapfile -t cwds < <(
      awk -F'\t' -v s="$sess" -v w="$widx" \
        '$1=="p" && $2==s && $3==w {print $4"\t"$6}' "$f" | sort -n | cut -f2-
    )
    [ ${#cwds[@]} -gt 0 ] || cwds=("$HOME")

    if [ "$first" = 1 ]; then
      tmux new-session -ds "$sess" -n "$wname" -c "${cwds[0]}"
      first=0
    else
      tmux new-window -t "$sess:" -n "$wname" -c "${cwds[0]}"
    fi

    # Recreate the remaining panes (rooted in their saved directories).
    i=1
    while [ "$i" -lt "${#cwds[@]}" ]; do
      tmux split-window -t "$sess:" -c "${cwds[$i]}"
      i=$((i + 1))
    done

    # Reapply the exact split geometry now that the pane count matches.
    tmux select-layout -t "$sess:" "$layout" 2>/dev/null || true

    [ "$wactive" = 1 ] && active_window="$widx"
  done < <(awk -F'\t' -v s="$sess" '$1=="w" && $2==s{print $3"\t"$4"\t"$5"\t"$6}' "$f" | sort -n)

  # Restore the active pane per window, then the active window for the session.
  while IFS=$'\t' read -r widx pidx; do
    [ -n "$widx" ] && tmux select-pane -t "$sess:$widx.$pidx" 2>/dev/null || true
  done < <(awk -F'\t' -v s="$sess" '$1=="p" && $2==s && $5==1{print $3"\t"$4}' "$f")

  [ -n "$active_window" ] && tmux select-window -t "$sess:$active_window" 2>/dev/null || true
done <<< "$sessions"

tmux display-message "tmux: restored sessions from $f"
