
{ config, lib, pkgs, ... }:

{
  home.file.".config/wofi.css".source = ./wofi.css;
}
