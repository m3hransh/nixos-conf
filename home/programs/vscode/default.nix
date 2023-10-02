{ config, lib, pkgs, ... }:

{
    # home.file.".config/Code/User/settings.json".source= ./settings.json;
    programs.vscode = {
      enable = true;
      userSettings = builtins.fromJSON (builtins.readFile ./settings.json );
  };
}
