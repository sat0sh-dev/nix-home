#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ssh-fwd.sh {start|stop|status} [host...]

Defaults to: home-dev-fwd-rdp home-dev-fwd-md
EOF
}

notify() {
  local msg="$1"
  if command -v osascript >/dev/null 2>&1; then
    osascript -e "display notification \"${msg}\" with title \"ssh-fwd\""
  elif command -v notify-send >/dev/null 2>&1; then
    notify-send "ssh-fwd" "$msg"
  else
    printf '%s\n' "$msg" >&2
  fi
}

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/ssh-fwd"
mkdir -p "$state_dir"

cmd="${1:-}"
shift || true

hosts=("$@")
if [ ${#hosts[@]} -eq 0 ]; then
  hosts=("home-dev-fwd-rdp" "home-dev-fwd-md")
fi

run_loop() {
  local host="$1"
  local stopfile="$state_dir/$host.stop"

  trap 'kill 0' INT TERM EXIT

  while true; do
    rm -f "$stopfile"
    ssh -N -T \
      -o ExitOnForwardFailure=yes \
      -o ServerAliveInterval=15 \
      -o ServerAliveCountMax=3 \
      "$host" &
    local child=$!
    wait "$child" || true

    if [ -f "$stopfile" ]; then
      rm -f "$stopfile"
      exit 0
    fi

    notify "Tunnel $host exited; reconnecting in 5s."
    sleep 5
  done
}

case "$cmd" in
  start)
    for host in "${hosts[@]}"; do
      pidfile="$state_dir/$host.pid"
      if [ -f "$pidfile" ] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
        printf '%s\n' "already running: $host"
        continue
      fi
      nohup "$0" _run "$host" >/dev/null 2>&1 &
      printf '%s\n' "$!" >"$pidfile"
      printf '%s\n' "started: $host"
    done
    ;;
  stop)
    for host in "${hosts[@]}"; do
      pidfile="$state_dir/$host.pid"
      stopfile="$state_dir/$host.stop"
      if [ -f "$pidfile" ] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
        printf '%s\n' "stopping: $host"
        printf '%s\n' "1" >"$stopfile"
        kill "$(cat "$pidfile")" 2>/dev/null || true
        rm -f "$pidfile"
      else
        printf '%s\n' "not running: $host"
      fi
    done
    ;;
  status)
    for host in "${hosts[@]}"; do
      pidfile="$state_dir/$host.pid"
      if [ -f "$pidfile" ] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
        printf '%s\n' "running: $host (pid $(cat "$pidfile"))"
      else
        printf '%s\n' "stopped: $host"
      fi
    done
    ;;
  _run)
    run_loop "${1:?host required}"
    ;;
  *)
    usage
    exit 1
    ;;
esac
