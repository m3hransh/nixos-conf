{ config, pkgs, hyprland, ... }:

{

  imports = [
    hyprland.homeManagerModules.default
    ./programs
  ];

  home = {
  username = "mehran";
  # paths it should manage.
  homeDirectory = "/home/mehran";
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  stateVersion = "23.05";
  };
  home.packages = with pkgs; 
    [ 
      vlc

      # utils
      wireguard-tools
      wlr-randr
      atool 
      httpie 
      lazygit 
      lazydocker
      dunst
      xflux
      pavucontrol

      #misc
      rofi

     ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output)
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
    ];
  };
  # programs.home-manager.enable = true;

  programs.starship = {
    enable = true;
  };
}
