{ config, pkgs, hyprland, ... }:

{

  imports = [
    hyprland.homeManagerModules.default
    ./programs
    ./scripts
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
      webcord
      vlc
      obsidian
      telegram-desktop
      mailspring
      mattermost-desktop
      firefox-wayland
      thunderbird

      # utils
      wireguard-tools
      wlr-randr
      atool 
      httpie 
      lazygit 
      lazydocker
      dunst
      xflux
      pavucontrol
      android-tools
      xfce.thunar
      jmtpfs

      # dev
      glab
      rustc
      go
      gcc
      nodejs
      nodePackages.npm
      nodePackages.yarn
      nodePackages.pnpm
      nodePackages.typescript
      cargo
      ripgrep
      python3Full 


      #misc
      rofi

     ];

  #programs.home-manager.enable = true;

  programs.starship = {
    enable = true;
  };
  programs.gh = {
    enable = true;
  };
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

  # GTK

  home.sessionVariables = {
    GTK_THEME = "Nordic";
  };
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors;
    name = "Catppuccin-Frappe-Dark";
    size = 16;
  };
  home.pointerCursor.gtk.enable = true;
  gtk = {
    enable = true;
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
    cursorTheme = {
      name = "Catppuccin-Frappe-Dark";
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };
    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';
  };
}
