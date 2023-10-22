{ config, pkgs, user, hostName, ... }:

{

  services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = user;
        };
        default_session = initial_session;
      };
  };

  security.pam.services.swaylock = { };

  xdg.portal = {
    enable = true;
    extraPortals= [pkgs.xdg-desktop-portal-gtk];
    wlr.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
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
  };

  environment.sessionVariables = {
    # if your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
}
