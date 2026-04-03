# NVIDIA ASUS laptop configuration (PRIME offload, CUDA, asusctl)
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
    ../common.nix
    ../hardware-configuration.nix
  ];

  # CUDA support
  nixpkgs.config.cudaSupport = true;

  # NVIDIA/ASUS-specific packages
  environment.systemPackages = with pkgs; [
    asusctl
    (cudaPackages.cudatoolkit.override { cudaSupport = true; })
    (openai-whisper.override { cudaSupport = true; })
  ];

  # NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    prime = {
      offload.enable = true;
      # Check: lspci | grep -i "VGA\|3D\|NVIDIA"
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.graphics.extraPackages = with pkgs; [
    libvdpau-va-gl
  ];

  # ASUS services
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  # CPU optimization for AMD Ryzen
  boot.kernelParams = [ "processor.max_cstate=1" ];
  powerManagement.cpuFreqGovernor = "performance";
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  # TLP power management (avoid clash with power-profiles-daemon)
  services.tlp.enable = lib.mkDefault (
    (lib.versionOlder (lib.versions.majorMinor lib.version) "21.05")
    || !config.services.power-profiles-daemon.enable
  );

  # Bluez udev rules
  services.udev.packages = [ pkgs.bluez ];
}
