{ pkgs, settings, ... }:

with settings;{

  imports = [
    # hyprland.homeManagerModules.default
     ./scripts.nix
    ../home/programs/ranger
    ../home/programs/resource_monitor
    ../home/programs/tmux
    ../home/programs/zoxide
    ../home/programs/nvim
    ../home/programs/kitty
    ../home/programs/nix-direnv
    #(./. + "/wm" + ("/" + userS.wm)) # My window manager
  ];

  home = {
    username = ubuntu.user;
    # paths it should manage.
    homeDirectory = "/home/" + ubuntu.user;
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    stateVersion = "23.11";
  };


  # The home.packages option allows you to install Nix packages into your
  # environment.
  fonts.fontconfig.enable = true;
  home.packages = (builtins.map (p: getPack p pkgs) (ubuntu.packages)) ++  
  (with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    inconsolata
    nerd-fonts.iosevka-term
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
  ]);

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
    "/home/${ubuntu.user}/.local/bin"
    "/home/${ubuntu.user}/.cargo/bin"
    "/home/${ubuntu.user}/.go/bin"
  ];


  programs.starship = {
    enable = true;
  };

  programs.gh = {
    enable = true;
  };

  # programs.fish = {
  #   enable = true;
  #   interactiveShellInit = ''
  #     set fish_greeting # Disable greeting
  #     direnv hook fish | source
  #   '';
  #   plugins = [
  #     # Enable a plugin (here grc for colorized command output)
  #     { name = "grc"; src = pkgs.fishPlugins.grc.src; }
  #   ];
  # };

  programs.git.enable = true;
  programs.git.userName = ubuntu.name;
  programs.git.userEmail = ubuntu.email;
  programs.git.extraConfig = {
    init.defaultBranch = "main";
    # safe.directory = "/home/" + userS.username + "/.dotfiles";
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

  # home.sessionVariables = {
  #   GTK_THEME = "Nordic";
  # };

  # home.pointerCursor = {
  #   package = pkgs.bibata-cursors;
  #   name = "Bibata-Modern-Ice";
  #   size = 22;
  # };

  qt.enable = true;
  gtk = {
    enable = true;
    # theme = {
    #   name = "Nordic";
    #   package = pkgs.nordic;
    # };
    # iconTheme = {
    #   name = "Papirus-Dark";
    #   package = pkgs.papirus-icon-theme;
    # };

    # font = {
    #   name = userS.font;
    #   size = 12;
    # };
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
