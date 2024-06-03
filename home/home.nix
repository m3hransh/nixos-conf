{ config, pkgs, userSettings, ... }:

{

  imports = [
    # hyprland.homeManagerModules.default
    #  ./scripts
    ./programs/zathura
    ./programs/vscode
    ./programs/ranger
    ./programs/imageview
    ./programs/kooha
    ./programs/mpv
    ./programs/music
    ./programs/obs-studio
    ./programs/resource_monitor
    ./programs/tmux
    #    ./search
    #    ./youtube-tui
    #    ./yt-dlp
    ./programs/nvim
    ./programs/kitty
    #    ./emacs
    ./programs/nix-direnv
    (./. + "/wm" + ("/" + userSettings.wm)) # My window manager
  ];

  home = {
    username = userSettings.user;
    # paths it should manage.
    homeDirectory = "/home/" + userSettings.user;
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    stateVersion = "23.11";
  };


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    brave
    google-chrome
    vlc
    obsidian
    telegram-desktop
    scrcpy
    discord
    thunderbird
    signal-desktop
    spotify
    anki-bin
    calibre
    xournalpp
    zotero

    lazygit
    lazydocker
    android-tools

    glab
    rustc
    cargo
    exercism
    go
    gcc
    nodejs
    nodePackages.npm
    nodePackages.yarn
    nodePackages.pnpm
    nodePackages.typescript
    jq

    # Local cert
    mkcert
    nssTools

    imv
    watson
    networkmanagerapplet
    brightnessctl
    libnotify
    wireguard-tools
    # wlr-randr
    atool
    httpie
    lazygit
    lazydocker
    #xflux
    android-tools
    jmtpfs
    scrcpy
    emote
    presenterm
    chezmoi
    fd
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ] ++ [ userSettings.fontPkg ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mehran/etc/profile.d/hm-session-vars.sh


  home.sessionPath = [
    "/home/${userSettings.user}/.local/bin"
    "/home/${userSettings.user}/.cargo/bin"
    "/home/${userSettings.user}/.go/bin"
  ];


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
      direnv hook fish | source
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output)
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
    ];
  };

  programs.git.enable = true;
  programs.git.userName = userSettings.name;
  programs.git.userEmail = userSettings.email;
  programs.git.extraConfig = {
    init.defaultBranch = "main";
    # safe.directory = "/home/" + userSettings.username + "/.dotfiles";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # GTK

  home.sessionVariables = {
    GTK_THEME = "Nordic";
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
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
      name = userSettings.font;
      size = 12;
    };
    # gtk3.extraConfig = {
    #   gtk-xft-antialias = 1;
    #   gtk-xft-hinting = 1;
    #   gtk-xft-hintstyle = "hintslight";
    #   gtk-xft-rgba = "rgb";
    # };
    # gtk2.extraConfig = ''
    #   gtk-xft-antialias=1
    #   gtk-xft-hinting=1
    #   gtk-xft-hintstyle="hintslight"

  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
