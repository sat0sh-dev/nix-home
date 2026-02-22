# ===== SSH Port Forwarding =====
#
# Usage: sshfwd [HOST] [-p PORT]
#
# Examples:
#   sshfwd                    # Connect to default host with port 3000
#   sshfwd myserver           # Connect to myserver with port 3000
#   sshfwd -p 3001            # Connect to default host with port 3001
#   sshfwd myserver -p 3001   # Connect to myserver with port 3001
#
# Installation:
#   Add to your ~/.zshrc:
#     source /path/to/sshfwd.zsh
#
#   Or copy the function directly to ~/.zshrc
#
# Configuration:
#   Change DEFAULT_HOST to match your ~/.ssh/config Host name

sshfwd() {
  local host="dev"  # デフォルトのホスト名（~/.ssh/configで定義）
  local port=3000

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -p|--port)
        port="$2"
        shift 2
        ;;
      -h|--help)
        echo "Usage: sshfwd [HOST] [-p PORT]"
        echo ""
        echo "Options:"
        echo "  -p, --port PORT  Port to forward (default: 3000)"
        echo "  -h, --help       Show this help"
        echo ""
        echo "Examples:"
        echo "  sshfwd                    # Connect to dev:3000"
        echo "  sshfwd myserver -p 3001   # Connect to myserver:3001"
        return 0
        ;;
      -*)
        echo "Unknown option: $1" >&2
        echo "Usage: sshfwd [HOST] [-p PORT]" >&2
        return 1
        ;;
      *)
        host="$1"
        shift
        ;;
    esac
  done

  echo "Connecting to $host with port forwarding: localhost:$port"
  ssh "$host" -L "${port}:localhost:${port}"
}
