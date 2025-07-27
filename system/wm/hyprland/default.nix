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
  # services.greetd = {
  #   enable = true;
  #   settings = rec {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland"; # Use TUI login
  #       user = userS.user;
  #     };
  #     default_session = initial_session;
  #   };
  # };
  # Ensure AccountsService is running (used by SDDM to get user info)
  services.accounts-daemon.enable = true;

  # Install the avatar to the expected path
  environment.etc."AccountsService/icons/${userS.user}".source = ../../../${userS.userIcon};
  # Generate the user metadata file
  environment.etc."AccountsService/users/${userS.user}".text = ''
    [User]
    Icon=/var/lib/AccountsService/icons/${userS.user}
  '';

  systemd.tmpfiles.rules = [
    "L /var/lib/AccountsService/icons/${userS.user} - - - - /etc/AccountsService/icons/${userS.user}"
    "L /var/lib/AccountsService/users/${userS.user} - - - - /etc/AccountsService/users/${userS.user}"
  ];
  environment.systemPackages = with pkgs; [
    (sddm-chili-theme.override {
      themeConfig = {
        background = config.stylix.image;
        blur = true;
        recursiveBlurLoops = 3;
        recursiveBlurRadius = 5;
      };
    })
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "chili";
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
