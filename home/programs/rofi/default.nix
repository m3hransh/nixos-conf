{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "kitty";
    theme = ./theme.rasi;
    extraConfig = {
      show-icons = true;
      icon-theme = "Papirus-Dark";
      display-drun = "";
      display-run = "";
      display-window = "";
      drun-display-format = "{name}";
      hover-select = true;
      me-select-entry = "";
      me-accept-entry = "MousePrimary";
    };
  };
}
