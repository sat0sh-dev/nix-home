# Common configuration shared by all systems
{ pkgs, lib, ... }:

{
  # Common packages available on all systems
  home.packages = with pkgs; [
    # Version control
    git
    gh

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
  ];

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # zsh configuration
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = lib.mkBefore ''
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
}
