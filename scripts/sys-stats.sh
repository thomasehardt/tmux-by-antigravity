#!/usr/bin/env bash
# Compact system stats for the status bar: 1-minute load average and memory
# used %. Both are cheap to read (no top sampling), so this is safe to run on
# every status refresh. Cross-platform support for macOS and Linux.
set -euo pipefail

if command -v sysctl >/dev/null 2>&1 && sysctl -n vm.loadavg >/dev/null 2>&1; then
  # macOS
  load=$(sysctl -n vm.loadavg 2>/dev/null | awk '{print $2}')
  freep=$(memory_pressure 2>/dev/null | awk -F: '/free percentage/{gsub(/[^0-9]/,"",$2); print $2}')
  
  if [ -n "${freep:-}" ]; then
    printf 'load %s  mem %d%%' "${load:-?}" "$((100 - freep))"
  else
    printf 'load %s' "${load:-?}"
  fi
else
  # Linux
  load=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')
  mem=$(free -m 2>/dev/null | awk '/^Mem:/{if ($2>0) printf "%.0f", ($3/$2)*100}')
  
  if [ -n "${mem:-}" ]; then
    printf 'load %s  mem %s%%' "${load:-?}" "$mem"
  else
    printf 'load %s' "${load:-?}"
  fi
fi
