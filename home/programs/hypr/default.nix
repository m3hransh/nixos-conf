{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hyprland-environment.nix
  ];


  home.packages = with pkgs; [ 
    swaylock-effects
    pamixer
    waybar
    wofi
    wl-clipboard
  ];
  # systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  #test later systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
    systemdIntegration = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };
}
