{ config, pkgs, settings, ... }:

with settings;{
  # Wayland with mutter is the default
  services.xserver = {
    enable = true;
    # Enable the GNOME Desktop Environment
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.forge
    xclip
    xsel
  ];

  services.udev.packages = with pkgs; [ gnome-settings-daemon ];
  services.gnome.gnome-keyring.enable = true;
}
