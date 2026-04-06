# AMD desktop configuration (ROCm, RADV, Ollama GPU acceleration)
{ config, pkgs, settings, lib, ... }:

with settings; {
  imports = [ ../common.nix ./hardware-configuration.nix ];

  # AMD-specific packages
  environment.systemPackages = with pkgs; [ clinfo rocmPackages.rocminfo ];

  # v2ray geodata
  environment.etc."v2ray/geosite.dat".source = pkgs.fetchurl {
    url =
      "https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat";
    sha256 = "1w6a4f1cp289gkgbk8z44fq3lliz5zgn38s2dz70f47q9ymgkxl5";
  };

  # AMD GPU driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  # ROCm OpenCL for RDNA4 / RX 9000-series
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    rocmPackages.clr
    rocmPackages.rocm-runtime
  ];

  # PipeWire extras: JACK support + Bluetooth codecs
  services.pipewire.jack.enable = true;
  nixpkgs.config.pipewire = {
    enableCodecAac = true;
    enableCodecAptx = true;
    enableCodecLdac = true;
  };

  # Ollama with ROCm GPU acceleration (RDNA4)
  services.ollama = {
    enable = true;
    environmentVariables = {
      HIP_VISIBLE_DEVICES = "0";
      HSA_OVERRIDE_GFX_VERSION = "12.0.1";
    };
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = "12.0.1";
  };
}
