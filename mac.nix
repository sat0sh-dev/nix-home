# macOS specific configuration
{ pkgs, ... }:

{
  # macOS-specific packages
  home.packages = with pkgs; [
    # macOS utilities
    pinentry_mac

    # Add more macOS-specific packages here
    # Example:
    # raycast (if available in nixpkgs)
    # iterm2 (if available in nixpkgs)
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
