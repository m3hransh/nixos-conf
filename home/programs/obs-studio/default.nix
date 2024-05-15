{ config, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins;
      [
        obs-backgroundremoval
      ];
  };
  home.file.".config/obs-studio/themes".source = ./themes;
}
