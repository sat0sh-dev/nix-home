# macOS specific configuration
{ pkgs, ... }:

{
  # macOS-specific packages
  home.packages = with pkgs; [
    # macOS utilities
    pinentry_mac

    # Terminal
    wezterm

    # Multimedia
    ffmpeg
  ];

  # macOS-specific environment variables
  home.sessionVariables = {
    # Example: macOS specific paths
    # HOMEBREW_PREFIX = "/opt/homebrew";
  };

  # macOS-specific programs configuration
  # Example:
  # programs.alacritty = {
  #   enable = true;
  #   settings = {
  #     # macOS specific settings
  #   };
  # };
}
