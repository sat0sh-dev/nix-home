# Ubuntu/Linux specific configuration
{ pkgs, ... }:

{
  # Linux-specific packages
  home.packages = with pkgs; [
    # Linux utilities
    pinentry-curses

    # Add more Linux-specific packages here
    # Example:
    # htop
    # docker-compose
  ];

  # Linux-specific environment variables
  home.sessionVariables = {
    # Example: Set display for X11
    # DISPLAY = ":0";
  };
}
