# Ubuntu/Linux specific configuration
{ config, pkgs, ... }:

{
  # Avoid user services failing in headless/SSH sessions.
  systemd.user.services = {
    gnome-terminal-server.Unit.ConditionEnvironment = "DISPLAY";
    xdg-desktop-portal.Unit.ConditionEnvironment = "DISPLAY";
    xdg-desktop-portal-gtk.Unit.ConditionEnvironment = "DISPLAY";
    xfce4-notifyd.Unit.ConditionEnvironment = "DISPLAY";
  };

  # Linux-specific packages
  home.packages = with pkgs; [
    # Linux utilities
    pinentry-curses
    xclip  # X11 clipboard tool (for tmux copy to system clipboard)

    # Android tools
    android-tools  # adb, fastboot

    # Emulators
    qemu  # For Yocto/AOSP image testing

    # VNC server + minimal X11 session
    tigervnc
    xorg.xauth
    xterm
    xorg.twm

    # XFCE desktop for VNC
    xfce.xfce4-session
    xfce4-panel
    xfce.xfce4-terminal
    xfce.xfwm4
    xfce.xfdesktop
    xfce.xfce4-settings
    xfconf
    dbus
    xdg-utils
  ];

  # VNC configuration (TigerVNC)
  home.file.".config/tigervnc/config".text = ''
    geometry=1920x1080
    localhost=yes
    alwaysshared
    session=xfce
  '';

  home.file.".config/tigervnc/xstartup" = {
    executable = true;
    text = ''
      #!/bin/sh
      unset SESSION_MANAGER
      unset DBUS_SESSION_BUS_ADDRESS

      ${pkgs.xorg.twm}/bin/twm &
      exec ${pkgs.xterm}/bin/xterm
    '';
  };

  home.file.".local/bin/vnc-session" = {
    executable = true;
    text = ''
      #!/bin/sh
      ${pkgs.xorg.twm}/bin/twm &
      exec ${pkgs.xterm}/bin/xterm
    '';
  };

  home.file.".local/bin/xfce-session" = {
    executable = true;
    text = ''
      #!/bin/sh
      # Ensure D-Bus session is available for XFCE
      LOG="${config.home.homeDirectory}/.config/tigervnc/xfce-session.log"
      # Include XFCE session config path for failsafe lookup
      XFCE_ETC="${pkgs.xfce.xfce4-session}/etc"
      if [ -n "$XDG_CONFIG_DIRS" ]; then
        export XDG_CONFIG_DIRS="$XFCE_ETC:$XDG_CONFIG_DIRS"
      else
        export XDG_CONFIG_DIRS="$XFCE_ETC"
      fi
      exec ${pkgs.dbus}/bin/dbus-run-session \
        --dbus-daemon=${pkgs.dbus}/bin/dbus-daemon \
        --config-file=${pkgs.dbus}/share/dbus-1/session.conf \
        -- \
        ${pkgs.xfce.xfce4-session}/bin/startxfce4 >>"$LOG" 2>&1
    '';
  };

  home.file.".local/share/xsessions/vnc.desktop".text = ''
    [Desktop Entry]
    Name=VNC Minimal
    Comment=Minimal VNC session (twm + xterm)
    Exec=${config.home.homeDirectory}/.local/bin/vnc-session
    Type=Application
  '';

}
