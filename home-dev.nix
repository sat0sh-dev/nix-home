# Ubuntu/Linux specific configuration
{ pkgs, ... }:

{
  # Linux-specific packages
  home.packages = with pkgs; [
    # Linux utilities
    pinentry-curses
    xclip  # X11 clipboard tool (for tmux copy to system clipboard)

    # Add more Linux-specific packages here
    # Example:
    # docker-compose
  ];

  # Linux-specific environment variables
  home.sessionVariables = {
    # Example: Set display for X11
    # DISPLAY = ":0";
  };
}
