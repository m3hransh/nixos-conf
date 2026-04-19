{ config, lib, pkgs, ... }:

{
  home.file.".config/ghostty/config" = {
    source = ./config;
  };

  home.file.".config/ghostty/shaders/cursor_smear.glsl" = {
    source = ./shaders/cursor_smear.glsl;
  };
}
