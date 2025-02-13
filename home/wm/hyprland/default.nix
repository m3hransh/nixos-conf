{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hyprland-environment.nix
    ../../programs/waybar
    ../../programs/wofi
    ../../programs/mako
  ];

  home.packages = with pkgs; [
    inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    swaylock-effects
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
    xfce.thunar
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

    extraConfig = builtins.readFile ./hyprland.conf;
  };

  home.file.".scripts" = {
    source = ./scripts;
    recursive = true;
  };
}
