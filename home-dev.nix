# Ubuntu/Linux specific configuration
{ pkgs, ... }:

let
  # AI Fallback System: ai-code wrapper script
  ai-code = pkgs.writeShellScriptBin "ai-code" ''
    #!/usr/bin/env bash

    # Colors for output
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    RESET='\033[0m'

    # Check if prompt is provided
    if [ $# -eq 0 ]; then
      echo -e "''${RED}Error: No prompt provided''${RESET}" >&2
      echo "Usage: ai-code \"<your prompt>\"" >&2
      exit 1
    fi

    # Combine all arguments as prompt
    PROMPT="$*"

    # Try Claude Code first
    echo -e "''${GREEN}[AI: Claude Code]''${RESET}" >&2

    # Execute Claude Code with -p (print mode)
    ERROR_OUTPUT=$(mktemp)
    if claude -p "$PROMPT" 2>"$ERROR_OUTPUT"; then
      # Success - clean up and exit
      rm -f "$ERROR_OUTPUT"
      exit 0
    fi

    # Check if error is rate limit related
    ERROR_TEXT=$(cat "$ERROR_OUTPUT")
    rm -f "$ERROR_OUTPUT"

    if echo "$ERROR_TEXT" | grep -qiE '(rate.?limit|usage.?limit|429)'; then
      # Rate limit detected - fallback to aider
      echo -e "''${YELLOW}[AI: Ollama + Aider (fallback - rate limit detected)]''${RESET}" >&2

      # Build aider command with context files
      AIDER_CMD="aider --yes --message \"$PROMPT\""

      # Add CLAUDE.md if it exists
      if [ -f "CLAUDE.md" ]; then
        AIDER_CMD="aider --read CLAUDE.md --yes --message \"$PROMPT\""
      fi

      # Add README.md if it exists
      if [ -f "README.md" ]; then
        AIDER_CMD="aider --read CLAUDE.md --read README.md --yes --message \"$PROMPT\""
      fi

      # Execute aider
      eval "$AIDER_CMD"
    else
      # Other error - display and exit
      echo -e "''${RED}Claude Code failed with non-rate-limit error:''${RESET}" >&2
      echo "$ERROR_TEXT" >&2
      exit 1
    fi
  '';
in
{
  # Linux-specific packages
  home.packages = with pkgs; [
    # Linux utilities
    pinentry-curses
    xclip  # X11 clipboard tool (for tmux copy to system clipboard)

    # AI Development Tools
    ollama       # Local LLM runtime
    aider-chat   # AI pair programming tool

    # AI Fallback System
    ai-code      # Wrapper script for Claude Code with Ollama fallback
  ];

  # Linux-specific environment variables
  home.sessionVariables = {
    # Ollama configuration
    OLLAMA_KEEP_ALIVE = "5m";  # Release memory 5 minutes after inference
  };
}
