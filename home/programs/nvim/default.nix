{ config, lib, inputs, pkgs, ... }:

{
  nixpkgs.config = {
    programs.npm.npmrc = ''
      prefix = ''${HOME}/.npm-global
    '';
  };
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      withPython3 = true;
      withNodeJs = true;
      extraPackages = [
      ];
      #-- Plugins --#
      plugins = with pkgs.vimPlugins;[ ];
      #-- --#
    };
  };
  home = {
    packages = with pkgs; [
      #-- LSP --#
      nodePackages_latest.typescript
      nodePackages_latest.typescript-language-server
      nodePackages_latest.vscode-langservers-extracted
      nodePackages_latest.bash-language-server
      # (haskell-language-server.override { supportedGhcVersions = [ "92" ]; })
      nil
      nixd
      lua-language-server
      gopls
      pyright
      zk
      rust-analyzer
      clang-tools
      # haskell-language-server
      ripgrep
      #-- tree-sitter --#
      tree-sitter
      #-- format --#
      stylua
      black
      nixpkgs-fmt
      rustfmt
      beautysh
      nodePackages.prettier
      # stylish-haskell
      xclip # for Xrog
      wl-clipboard
      marksman
      #-- Debug --#
      # lldb
    ];
  };

  # home.file.".config/nvim/init.lua".source = ./init.lua;
  # home.file.".config/nvim/lua".source = ./lua;
}
