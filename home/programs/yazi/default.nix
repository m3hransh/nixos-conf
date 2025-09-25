{ pkgs, config, ... }:
{
  home.file.".config/yazi" = {
    source = ./config;
    recursive = true;
  };
}
