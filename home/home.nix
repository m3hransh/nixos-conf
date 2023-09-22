{ config, pkgs, hyprland, ... }:

{

  imports = [
    hyprland.homeManagerModules.default
    ./programs
  ];

  home = {
  username = "mehran";
  # paths it should manage.
  homeDirectory = "/home/mehran";
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  stateVersion = "23.05";
  };
  home.packages = with pkgs; 
    [ 
      # app
      brave
      google-chrome
      discord
      vlc
      obsidian
      telegram-desktop
      mailspring
      mattermost-desktop

      # utils
      ranger
      wireguard-tools
      wlr-randr
      atool 
      httpie 
      lazygit 
      lazydocker
      dunst
      xflux
      pavucontrol

      # dev
      vscode
      gh
      glab
      rustc
      rust-analyzer
      go
      gcc
      nodejs
      nodePackages.npm
      nodePackages.yarn
      nodePackages.pnpm
      nodePackages.typescript
      nodePackages.typescript-language-server
      lua-language-server
      cargo
      stylua
      ripgrep
      marksman
      tree-sitter
      python3Full 


      #misc
      rofi

     ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output)
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
    ];
  };
  # programs.home-manager.enable = true;

  programs.starship = {
    enable = true;
  };
}
