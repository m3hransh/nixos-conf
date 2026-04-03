{ config, pkgs, settings, ... }:

{
  home = {
    sessionVariables =
      {
        EDITOR = "nvim";
        BROWSER = "brave";
        TERMINAL = "kitty";
        __GL_VRR_ALLOWED = "1";
        CLUTTER_BACKEND = "wayland";
      }
      // (
        if settings.systemS.machine == "ASUS"
        then {
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          LIBVA_DRIVER_NAME = "nvidia";
        }
        else {
          LIBVA_DRIVER_NAME = "radeonsi";
        }
      );
  };
}
