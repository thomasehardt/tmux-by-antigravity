#!/usr/bin/env bash
# Platform-agnostic battery segment for the status bar. Prints e.g. "85%" or
# "85%+" while charging. Stays completely silent on desktops that have no
# battery, so the status bar simply omits it rather than showing an empty label.

if command -v pmset >/dev/null 2>&1; then
  raw=$(pmset -g batt 2>/dev/null) || exit 0
  pct=$(printf '%s\n' "$raw" | grep -Eo '[0-9]+%' | head -n1)
  [ -z "${pct:-}" ] && exit 0
  case "$raw" in
    *'AC Power'*|*charging*) suffix='+' ;;
    *) suffix='' ;;
  esac
  printf '%s%s' "$pct" "$suffix"
elif [ -d /sys/class/power_supply/ ]; then
  bat=$(ls -1d /sys/class/power_supply/BAT* 2>/dev/null | head -n1 || true)
  [ -z "$bat" ] && exit 0
  cap=$(cat "$bat/capacity" 2>/dev/null || true)
  [ -z "$cap" ] && exit 0
  stat=$(cat "$bat/status" 2>/dev/null || true)
  case "$stat" in
    Charging) suffix='+' ;;
    *) suffix='' ;;
  esac
  printf '%s%%%s' "$cap" "$suffix"
fi
