{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      ranger
    ];
  };
  home.file.".config/ranger".source = ./config;
}
