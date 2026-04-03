# Shared system configuration for all hardware profiles.
{
  config,
  pkgs,
  settings,
  lib,
  ...
}:

with settings;
{
  imports = [
    ./style.nix
    (./. + "/wm" + ("/" + userS.wm))
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [
    "ext4"
    "vfat"
    "ntfs"
  ];

  # Nix settings
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = [
      "root"
      userS.user
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Packages from settings.toml
  environment.systemPackages =
    builtins.map (pkg: getPack pkg pkgs) systemS.packages;

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Programs
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.fish.enable = true;
  programs.light.enable = true;
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };
  programs.dconf.enable = true;
  programs.nix-ld.enable = true;

  # Graphics (base)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Services
  services.gvfs.enable = true;
  services.printing.enable = true;
  services.openssh.enable = true;
  services.fstrim.enable = lib.mkDefault true;

  # PipeWire audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;

  # Security
  security.rtkit.enable = true;

  # User account
  users.users.${userS.user} = {
    isNormalUser = true;
    description = userS.user;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "video"
      "kvm"
      "audio"
      "fuse"
      "adbusers"
      "libvirtd"
    ];
  };
  users.defaultUserShell = pkgs.fish;

  # Docker
  virtualisation.docker.enable = true;

  # Networking
  networking.hostName = systemS.hostName;
  networking.networkmanager.enable = true;
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces.wg0 = {
    configFile = "/etc/wireguard/wind.conf";
    autostart = false;
  };
  networking.wg-quick.interfaces.wg1 = {
    configFile = "/etc/wireguard/rptu.conf";
    autostart = false;
  };

  # Locale
  time.timeZone = "Europe/Berlin";
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

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    inconsolata
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = systemS.stateVersion;
}
