{ config, pkgs, user, hostName, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neofetch
    vim 
    wget
    unzip
    # terminal
    kitty
    starship
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fzf
    fishPlugins.grc
    grc
  ];

  programs.fish.enable = true;
  programs.light.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  programs.dconf.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  }
