# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, settings, lib, ... }:

with settings;{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (./. + "/wm" + ("/" + userS.wm)) # My window manager
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Activating nix-command and flake
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (builtins.map (pkg: getPack pkg pkgs) systemS.packages) ++
    (if (systemS.system == "ASUS") then [
      pkgs.asusctl
    ] else [ ]);

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
  # programs.droidcam.enable = true;
  # programs.firefox.enable = true;
  programs.adb.enable = true;

  # If asus laptop install asusctl package
  # if systemS.system == "ASUS" then
  #Garbage colector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  services.gvfs.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
  };
  #NvidiaConfig
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.supergfxd.enable = true;
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
  # fixes mic mute button
  # services.udev.extraHwdb = ''
  #   evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
  #    KEYBOARD_KEY_ff31007c=f20
  # '';

  # CPU optimization for amd ryzen
  boot.kernelParams = [ "processor.max_cstate=1" ];
  powerManagement.cpuFreqGovernor = "performance";
  # Update the CPU microcode for AMD processors.
  # Don't know if it's applied
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  security.pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" /etc/ssl/certs/localhost.crt ];
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  nix.settings.trusted-users = [ "root" userS.user ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userS.user} = {
    isNormalUser = true;
    description = userS.user;
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "kvm" "audio" "fuse" "adbusers" "libvirtd" ];
  };


  users.defaultUserShell = pkgs.fish;

  # Enable docker
  virtualisation.docker.enable = true;

  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ userS.user ];
  virtualisation.libvirtd.enable = true;

  # Networking
  networking.hostName = systemS.hostName; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Locale

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

  # Fonts

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    inconsolata
    (nerdfonts.override { fonts = [ "FiraCode" "CascadiaCode" "Iosevka" "IosevkaTerm" "JetBrainsMono" ]; })
  ];

  # Whether to enable all firmware regardless of license status.
  hardware.enableAllFirmware = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
