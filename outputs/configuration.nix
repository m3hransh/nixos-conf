# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # Activating nix-command and flake
  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = "mehran-rog"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the KDE Plasma Desktop Environment.
  #services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us,de,ir";
    xkbVariant = "";
    xkbOptions = "grp:win_space_toggle";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.sessionVariables = {
    # if your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };
  #NvidiaConfig
  hardware.opengl = {
    enable = true;
  #  driSupport = true;
  #  driSupport32Bit = true;
  };


  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
#
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable docker
  virtualisation.docker.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mehran = {
    isNormalUser = true;
    description = "mehran";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "kvm" "audio"];
  };

  users.defaultUserShell = pkgs.fish;

  programs.fish.enable = true;


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neofetch
    vim 
    wget
    kitty
    neovim
    vscode
    cargo
    rustc
    rust-analyzer
    unzip
    stylua
    lua-language-server
    marksman
    go
    google-chrome
    gcc
    nodejs
    nodePackages.npm
    nodePackages.yarn
    nodePackages.pnpm
    nodePackages.typescript
    nodePackages.typescript-language-server
    tree-sitter
    python3Full 
    git
    gh
    glab
    wl-clipboard
    ripgrep
    stylua
    discord
    brave
    chezmoi
    starship
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fzf
    fishPlugins.grc
    grc
    libsForQt5.bismuth
    obsidian
    telegram-desktop
    mailspring
    ranger
    mattermost-desktop
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" "CascadiaCode" "Iosevka" "IosevkaTerm" "JetBrainsMono"];} )
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # Neovim Configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    
  };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
