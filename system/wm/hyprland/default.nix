{
  config,
  pkgs,
  settings,
  inputs,
  ...
}:

with settings;
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland"; # Use TUI login
        user = userS.user;
      };
    };
  };

  security.pam.services.swaylock = { };

  xdg.portal = {
    config.common.default = "*";
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    wlr.enable = true;
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # Fix invisible cursor
    NIXOS_OZONE_WL = "1"; # Enable Wayland for Electron apps
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
}
