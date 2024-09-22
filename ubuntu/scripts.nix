{ config, lib, pkgs, ... }:

let
  unittests = pkgs.writeShellScriptBin "unittests" ''
    make -C /home/$USER/Projects/check_mk/tests test-unit
  '';
in
{
  home.packages = with pkgs; [
    unittests
    ];
}
