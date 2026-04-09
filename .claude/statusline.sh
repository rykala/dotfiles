#!/usr/bin/env bash
set -euo pipefail

data=$(cat)

five_h=$(echo "$data" | jq -r '.rate_limits.five_hour.used_percentage // 0')
seven_d=$(echo "$data" | jq -r '.rate_limits.seven_day.used_percentage // 0')
ctx=$(echo "$data" | jq -r '.context_window.used_percentage // 0')
cost=$(echo "$data" | jq -r '.cost.total_cost_usd // 0')

colorize() {
  local val=${1%.*}  # truncate to int
  val=${val:-0}
  if [ "$val" -gt 80 ]; then
    printf '\033[31m'  # red
  elif [ "$val" -gt 50 ]; then
    printf '\033[33m'  # yellow
  else
    printf '\033[32m'  # green
  fi
}

reset='\033[0m'

printf "$(colorize "$five_h")5h: %s%%${reset} | $(colorize "$seven_d")7d: %s%%${reset} | $(colorize "$ctx")ctx: %s%%${reset} | \$%.2f\n" \
  "$five_h" "$seven_d" "$ctx" "$cost"
