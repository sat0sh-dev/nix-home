# Ubuntu/Linux specific configuration
{ pkgs, ... }:

{
  # Linux-specific packages
  home.packages = with pkgs; [
    # Linux utilities
    pinentry-curses
    xclip  # X11 clipboard tool (for tmux copy to system clipboard)
  ];
}
