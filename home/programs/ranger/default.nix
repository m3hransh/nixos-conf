{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      ranger
      xdragon
    ];
  };
  home.file.".config/ranger" = {
    source = ./config;
    recursive = true;
  };
}
