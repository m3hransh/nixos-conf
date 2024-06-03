{ pkgs, ... }:

{
  # home.file.".config/Code/User/settings.json".source= ./settings.json;
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    # the setting is not mutable
    # userSettings = builtins.fromJSON (builtins.readFile ./settings.json );
  };
}
