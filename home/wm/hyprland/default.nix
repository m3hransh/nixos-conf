{ config, lib, pkgs, ... }:

{
  imports = [
    ./hyprland-environment.nix
    ../../programs/waybar
    ../../programs/wofi
    ../../programs/mako
  ];

  home.packages = with pkgs; [
    grimblast
    hyprpicker
    hyprlock
    pamixer
    waybar
    wofi
    wofi-emoji
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

  home.file.".scripts" = {
    source = ./scripts;
    recursive = true;
  };
}
