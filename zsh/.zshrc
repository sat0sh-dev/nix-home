# ===== Nix initialization =====
# --- Nix initialization (Ubuntu multi-user install) ---
if [ -e /etc/profile.d/nix.sh ]; then
  . /etc/profile.d/nix.sh
fi

# Nix profile binaries
export PATH="$HOME/.nix-profile/bin:$PATH"

# User local binaries
export PATH="$HOME/.local/bin:$PATH"

# User custom binaries
export PATH="$HOME/bin:$PATH"

# ===== Environment variables =====
export EDITOR=nvim

# Claude API key (for codecompanion.nvim)
# Stored in ~/.anthropic_key (not tracked by git)
if [ -f ~/.anthropic_key ]; then
  source ~/.anthropic_key
fi

# ===== History settings =====
HISTFILE=~/.zsh_history
HISTSIZE=10000                   # Number of commands to remember in memory
SAVEHIST=10000                   # Number of commands to save to file

# History options
setopt SHARE_HISTORY             # Share history across all sessions
setopt HIST_IGNORE_ALL_DUPS      # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks from history
setopt HIST_IGNORE_SPACE         # Don't save commands starting with space
setopt HIST_VERIFY               # Show command before executing from history
setopt INC_APPEND_HISTORY        # Add commands to history immediately
setopt HIST_FIND_NO_DUPS         # Don't show duplicates when searching

# ===== Aliases =====
# Basic commands
alias ll='ls -alh'
alias v='nvim'
alias c='clear'
alias h='history'
alias reload='exec zsh'

# Git
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate'
alias gst='git stash'
alias lg='lazygit'  # Git TUI

# Nix/Home-Manager
alias hms='cd ~/nix-home && nix run home-manager/master -- switch --flake .#home-dev --impure'
alias hme='cd ~/nix-home && nvim'

# Home-Manager with target selection (primarily for macOS)
gms() {
  local target="${1:-mac}"
  cd ~/nix-home && nix run home-manager/master -- switch --flake .#${target} --impure
}

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'

# Safety (confirmation prompts)
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Utilities
alias grep='grep --color=auto'
alias path='echo $PATH | tr ":" "\n"'
alias ports='netstat -tulanp'

# ===== Custom settings =====
# Add your custom zsh settings below

# ===== Keybindings =====
# Vim-style history navigation
bindkey '^P' up-line-or-history      # Ctrl+p: Previous command
bindkey '^N' down-line-or-history    # Ctrl+n: Next command

# ===== zsh-autosuggestions settings =====
# Accept suggestion with right arrow (entire line)
bindkey '^[[C' forward-char          # Right arrow: move cursor (not accept suggestion)
bindkey '^F' autosuggest-accept      # Ctrl+f: accept entire suggestion
bindkey '^[f' forward-word           # Alt+f: accept one word

# Clear autosuggestion with Escape
bindkey '^[' autosuggest-clear       # Escape: clear suggestion

# ===== fzf (Fuzzy Finder) =====
# Ctrl+r: Interactive history search
# Ctrl+t: Fuzzy file search
if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

# fzf configuration
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --color=fg:#d4d4d4,bg:#1e1e1e,hl:#569cd6
  --color=fg+:#d4d4d4,bg+:#264f78,hl+:#4ec9b0
  --color=info:#ce9178,prompt:#4ec9b0,pointer:#c586c0
  --color=marker:#4ec9b0,spinner:#ce9178,header:#569cd6
'

# ===== direnv integration =====
# Automatically load .envrc when entering directories
eval "$(direnv hook zsh)"

# nix-direnv configuration
# Use nix-direnv for better performance with flakes
export DIRENV_LOG_FORMAT=""  # Reduce noise (optional)

# ===== Starship prompt =====
eval "$(starship init zsh)"
# AOSP tmux shortcuts
alias ta='tmux attach -t aosp'
alias tk='tmux kill-session -t aosp'
