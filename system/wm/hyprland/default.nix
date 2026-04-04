{ pkgs, settings, ... }:

with settings; {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = userS.user;
      };
    };
  };

  # Optional but recommended: Keep the TTY clean so tuigreet looks nice
  # This prevents systemd boot messages from printing over the login screen
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError =
      "journal"; # Routes errors to journalctl instead of the screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
  security.pam.services.hyprlock = { };

  xdg.portal = {
    config.common.default = "*";
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # wlr portal not needed -- Hyprland ships xdg-desktop-portal-hyprland
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart =
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Enable Wayland for Electron apps
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
}
