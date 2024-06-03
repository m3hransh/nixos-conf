{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    # the setting is not mutable
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
