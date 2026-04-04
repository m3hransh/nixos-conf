{ config, lib, pkgs, ... }:

{
  imports = [
    ./hyprland-environment.nix
    ../../programs/waybar
    ../../programs/rofi
    ../../programs/mako
  ];

  home.packages = with pkgs; [
    grimblast
    hyprpicker
    hyprlock
    hypridle
    pamixer
    waybar
    rofimoji
    wl-clipboard
    wlr-randr
    pavucontrol
    hyprpaper
    hyprsunset
    nwg-displays
    # file manager for hyprland
    thunar
    # swww
  ];
  # systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  #test later systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];

  wayland.windowManager.hyprland = {
    enable = true;
    # enableNvidiaPatches = true;
    xwayland.enable = true;
    # systemdIntegration = true;
    # systemd.enable = true;

    systemd.variables = [ "--all" ];

    # If you configure your Hyprland settings via Home Manager,
    # you must disable Home Manager's built-in systemd integration.
    # Because UWSM is now handling systemd on the NixOS system level, leaving it enabled in Home Manager will cause conflicts and crashes.
    systemd.enable = false;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300; # 5 min
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600; # 10 min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 900; # 15 min
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  home.file.".scripts" = {
    source = ./scripts;
    recursive = true;
  };
}
