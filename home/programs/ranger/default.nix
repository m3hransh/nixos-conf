{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      ranger
      dragon-drop
    ];
  };
  home.file.".config/ranger" = {
    source = ./config;
    recursive = true;
  };
}
