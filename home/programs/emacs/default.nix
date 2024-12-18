{ config, lib, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk; # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
    extraConfig = builtins.readFile ./init.el;
    extraPackages = epkgs:
      (with epkgs; [
        treesit-grammars.with-all-grammars
        agda2-mode
      ]) ++
      (with epkgs.elpaPackages; [
        # auctex
        # company
        # rec-mode
        # yasnippet
      ]) ++
      (with epkgs.melpaStablePackages; [
        # deadgrep
        # direnv
        # elixir-mode
        # fuel
        # go-mode
        # haskell-mode
        # highlight-indentation
        # markdown-mode
        # nix-mode
        # slime
        # smartparens
        # yaml-mode
      ]) ++
      (with epkgs.melpaPackages; [
        # toml-mode
      ]);
  };
}
