{  pkgs, inputs, settings, ... }:

let
  # themePath = "../../../themes"+("/"+userSettings.theme+"/"+userSettings.theme)+".yaml";
  # themePolarity = lib.removeSuffix "\n" (builtins.readFile (./. + "../../../themes"+("/"+userSettings.theme)+"/polarity.txt"));
  # backgroundUrl = builtins.readFile (./. + "../../../themes"+("/"+userSettings.theme)+"/backgroundurl.txt");
  # backgroundSha256 = builtins.readFile (./. + "../../../themes/"+("/"+userSettings.theme)+"/backgroundsha256.txt");
in
with settings;{
  imports = [ inputs.stylix.homeModules.stylix ];

  home.packages = with pkgs; [ base16-schemes ];
  stylix.enable = true;
  # home.file.".currenttheme".text = userSettings.theme;
  stylix.autoEnable = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyodark.yaml";
  stylix.polarity = "dark";
  stylix.image = pkgs.fetchurl {
    url = "https://r4.wallpaperflare.com/wallpaper/643/872/938/astronaut-relaxing-black-background-floater-space-hd-wallpaper-58a65d781020dc68109c91ee5842b45a.jpg";
    sha256 = "f12b95cecfbca53656d61702f951f6c6b1318b8bd6e5d2a2390c063647128baa";
  };
  stylix.fonts = {
    monospace = {
      name = userS.font;
      package = pkgs.${userS.fontPkg};
    };
    serif = {
      name = userS.font;
      package = pkgs.${userS.fontPkg};
    };
    sansSerif = {
      name = userS.font;
      package = pkgs.${userS.fontPkg};
    };
    emoji = {
      name = "Noto Emoji";
      package = pkgs.noto-fonts-monochrome-emoji;
    };
    sizes = {
      terminal = 18;
      applications = 12;
      popups = 12;
      desktop = 12;
    };
  };

  stylix.iconTheme = {
    enable = true;
    package = pkgs.papirus-icon-theme;
    dark = "Papirus-Dark";
  };
  #
  # font.size = config.stylix.fonts.sizes.terminal;
  # font.normal.family = userS.font;
  # };
  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
  };
  # stylix.targets.kde.enable = true;
  stylix.targets.kitty.enable = true;
  stylix.targets.gtk.enable = true;
  stylix.targets.hyprland.enable = true;
  stylix.targets.hyprlock.enable = true;
  # stylix.targets.hyprland.hyprpaper.enable = true;
  # stylix.targets.rofi.enable = if (userSettings.wmType == "x11") then true else false;
  # stylix.targets.feh.enable = if (userSettings.wmType == "x11") then true else false;
  # programs.feh.enable = true;
  # home.file.".fehbg-stylix".text = ''
  #   #!/bin/sh
  #   feh --no-fehbg --bg-fill ''+config.stylix.image+'';
  # '';
  # home.file.".fehbg-stylix".executable = true;
  # home.file = {
  #   ".config/qt5ct/colors/oomox-current.conf".source = config.lib.stylix.colors {
  #     template = builtins.readFile ./oomox-current.conf.mustache;
  #     extension = ".conf";
  #   };
  #   ".config/Trolltech.conf".source = config.lib.stylix.colors {
  #     template = builtins.readFile ./Trolltech.conf.mustache;
  #     extension = ".conf";
  #   };
  #   ".config/kdeglobals".source = config.lib.stylix.colors {
  #     template = builtins.readFile ./Trolltech.conf.mustache;
  #     extension = "";
  #   };
  #   ".config/qt5ct/qt5ct.conf".text = pkgs.lib.mkBefore (builtins.readFile ./qt5ct.conf);
  # };
  # home.file.".config/hypr/hyprpaper.conf".text = ''
  #   preload = '' + config.stylix.image + ''
  #   wallpaper = ,'' + config.stylix.image + ''
  #  '';
  # home.packages = with pkgs; [
  #    libsForQt5.qt5ct pkgs.libsForQt5.breeze-qt5 libsForQt5.breeze-icons pkgs.noto-fonts-monochrome-emoji
  # ];
  # qt = {
  #   enable = true;
  #   style.package = pkgs.libsForQt5.breeze-qt5;
  #   style.name = "breeze-dark";
  #   platformTheme = "kde";
  # };
  # fonts.fontconfig.defaultFonts = {
  #   monospace = [ userSettings.font ];
  #   sansSerif = [ userSettings.font ];
  #   serif = [ userSettings.font ];
  # };
}
