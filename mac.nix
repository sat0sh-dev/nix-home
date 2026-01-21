# macOS specific configuration
{ pkgs, ... }:

{
  # macOS-specific packages
  home.packages = with pkgs; [
    # macOS utilities
    pinentry_mac
    android-tools  # adb/fastboot for Android debugging

    # Terminal
    wezterm

    # Fonts
    nerd-fonts.hack  # Hack Nerd Font
    nerd-fonts.jetbrains-mono  # JetBrains Mono Nerd Font
    source-han-code-jp  # Adobe's programming font with excellent Japanese support
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
