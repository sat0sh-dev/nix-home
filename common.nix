# Common configuration shared by all systems
{ pkgs, lib, ... }:

{
  # Common packages available on all systems
  home.packages = with pkgs; [
    # Version control
    git
    gh
    lazygit  # Terminal UI for git

    # Search tools
    ripgrep
    fd
    fzf

    # Network tools
    curl
    wget
    jq

    # System utilities
    htop
    tmux

    # Development tools
    nodejs
    pass
    gnupg
    jdk17
    kotlin
    kotlin-language-server
    ktlint

    # Container tools
    podman

    # Shell
    starship
    direnv
    nix-direnv
  ];

  # Add ~/bin to PATH
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.npm-global/bin"
  ];

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    JAVA_HOME = "${pkgs.jdk17}";
  };

  # Install global npm packages for AI CLIs
  home.activation.installNpmGlobal = lib.hm.dag.entryAfter ["installPackages"] ''
    NPM_BIN="${pkgs.nodejs}/bin/npm"
    if [ -x "$NPM_BIN" ]; then
      export PATH="${pkgs.nodejs}/bin:$PATH"
      NPM_PREFIX="$HOME/.npm-global"
      mkdir -p "$NPM_PREFIX"
      "$NPM_BIN" config set prefix "$NPM_PREFIX" >/dev/null 2>&1

      for pkg in @openai/codex @anthropic-ai/claude-code @google/gemini-cli; do
        if ! "$NPM_BIN" list -g --depth=0 "$pkg" >/dev/null 2>&1; then
          echo "Installing $pkg via npm..."
          "$NPM_BIN" install -g "$pkg"
        fi
      done
    else
      echo "npm not found; skipping global npm installs."
    fi
  '';

  # zsh configuration
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    envExtra = ''
      export PATH="$HOME/.npm-global/bin:$HOME/bin:$HOME/.local/bin:$PATH"
    '';
    initContent = lib.mkBefore ''
      # Source ~/nix-home/zsh/.zshrc
      if [ -f "$HOME/nix-home/zsh/.zshrc" ]; then
        source "$HOME/nix-home/zsh/.zshrc"
      fi
    '';
  };

  # neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Ensure zsh config is loaded even when ZDOTDIR points to ~/.config/zsh
  home.file.".config/zsh/.zshenv".text = ''
    if [ -f "$HOME/.zshenv" ]; then
      . "$HOME/.zshenv"
    fi
  '';
  home.file.".config/zsh/.zshrc".text = ''
    if [ -f "$HOME/.zshrc" ]; then
      . "$HOME/.zshrc"
    fi
  '';
}
