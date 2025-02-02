# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, settings, lib, ... }:

with settings;{
  imports =
    [
      # Include the results of the hardware scan.
      ./style.nix
      ./hardware-configuration.nix
      (./. + "/wm" + ("/" + userS.wm)) # My window manager
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ext4" "vfat" "ntfs" ];

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
    powerManagement.enable = true;
    # model = "asus-zephyrus-ga503"
    prime = {
      offload.enable = true;
      # Check     lspci | grep -i "VGA\|3D\|NVIDIA"
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  #NvidiaConfig
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Accelerated video Playback
      libvdpau-va-gl
    ];
  };


  # Use prime instead 
  # services.supergfxd.enable = true;
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
  hardware.enableRedistributableFirmware = true; # In configuration.nix

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

  # # Note : if service didn't start
  # # sudo chown -R ollama:ollama /mnt/windows/ollama
  # # sudo chown -R ollama:ollama /mnt/windows/ollama/models
  # services.ollama = {
  #   enable = true;
  #   home = "/mnt/windows/ollama";
  #   models = "/mnt/windows/ollama/models";
  #   user = "ollama";
  #   group = "ollama";
  #   acceleration = "cuda";
  # };
  #
  # services.open-webui = {
  #   enable = true;
  #   port = 8080;
  # };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
    # Bluetooth enhancements
  };
  # Bluetooth
  services.blueman.enable = true;
  services.udev.packages = [ pkgs.bluez ];

  # Gnome 40 introduced a new way of managing power, without tlp.
  # However, these 2 services clash when enabled simultaneously.
  # https://github.com/NixOS/nixos-hardware/issues/260
  services.tlp.enable = lib.mkDefault ((lib.versionOlder (lib.versions.majorMinor lib.version) "21.05")
    || !config.services.power-profiles-daemon.enable);

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # SSD
  services.fstrim.enable = lib.mkDefault true;
  # security.pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" /etc/ssl/certs/localhost.crt ];
  services.pulseaudio.enable = false;
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

  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };
  # Enable WireGuard
  networking.wireguard.enable = true;
  networking.wg-quick.interfaces.wg0 = { configFile = "/etc/wireguard/wind.conf"; autostart = false; };
  networking.wg-quick.interfaces.wg1 = { configFile = "/etc/wireguard/rptu.conf"; autostart = false; };
  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ userS.user ];
  # virtualisation.libvirtd = {
  #   enable = true;
  #   qemu = {
  #     package = pkgs.qemu_kvm;
  #     runAsRoot = true;
  #     swtpm.enable = true;
  #     ovmf = {
  #       enable = true;
  #       packages = [
  #         (pkgs.OVMF.override {
  #           secureBoot = true;
  #           tpmSupport = true;
  #         }).fd
  #       ];
  #     };
  #   };
  # }; # Networking
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
    noto-fonts-cjk-sans
    noto-fonts-emoji
    inconsolata
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-mono
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.jetbrains-mono
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
