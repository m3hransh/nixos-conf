{ lib, pkgs, inputs, settings, ... }:

let
  # themePath = "../../../themes/" + userSettings.theme + "/" + userSettings.theme + ".yaml";
  # themePolarity = lib.removeSuffix "\n" (builtins.readFile (./. + "../../../themes" + ("/" + userSettings.theme) + "/polarity.txt"));
  # myLightDMTheme = if themePolarity == "light" then "Adwaita" else "Adwaita-dark";
  # backgroundUrl = builtins.readFile (./. + "../../../themes" + ("/" + userSettings.theme) + "/backgroundurl.txt");
  # backgroundSha256 = builtins.readFile (./. + "../../../themes/" + ("/" + userSettings.theme) + "/backgroundsha256.txt");
in
with settings;{
  imports = [ inputs.stylix.nixosModules.stylix ];
  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.polarity = "dark";
  stylix.image = pkgs.fetchurl {
    url = "https://r4.wallpaperflare.com/wallpaper/642/695/642/anime-demon-slayer-kimetsu-no-yaiba-giyuu-tomioka-hd-wallpaper-3d168c86bf53609f96e6ec093ffdb04e.jpg";
    sha256 = "035sgg5ay3carbqvlns5vxqpqlh2i2xfn1399yzk2wlc4vf4bvl7";
  };
  # stylix.base16Scheme = ./. + themePath;
  stylix.fonts = {
    # monospace = {
    #   name = userS.font;
    #   package = userS.fontPkg;
    # };
    # serif = {
    #   name = userS.font;
    #   package = userS.fontPkg;
    # };
    # sansSerif = {
    #   name = userS.font;
    #   package = userS.fontPkg;
    # };
    emoji = {
      name = "Noto Color Emoji";
      package = pkgs.noto-fonts-emoji-blob-bin;
    };
  };

  # stylix.targets.ssdm.enable = true;
  # services.xserver.displayManager.lightdm = {
  #   greeters.slick.enable = true;
  #   greeters.slick.theme.name = myLightDMTheme;
  # };
  stylix.targets.console.enable = true;

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

}
