{
  pkgs,
  inputs,
  settings,
  ...
}:

let
  # themePath = "../../../themes/" + userSettings.theme + "/" + userSettings.theme + ".yaml";
  # themePolarity = lib.removeSuffix "\n" (builtins.readFile (./. + "../../../themes" + ("/" + userSettings.theme) + "/polarity.txt"));
  # myLightDMTheme = if themePolarity == "light" then "Adwaita" else "Adwaita-dark";
  # backgroundUrl = builtins.readFile (./. + "../../../themes" + ("/" + userSettings.theme) + "/backgroundurl.txt");
  # backgroundSha256 = builtins.readFile (./. + "../../../themes/" + ("/" + userSettings.theme) + "/backgroundsha256.txt");
in
with settings;
{
  # imports = [ inputs.stylix.nixosModules.stylix ];
  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.polarity = "dark";
  stylix.image = pkgs.fetchurl {
    url = "https://r4.wallpaperflare.com/wallpaper/643/872/938/astronaut-relaxing-black-background-floater-space-hd-wallpaper-58a65d781020dc68109c91ee5842b45a.jpg";
    sha256 = "f12b95cecfbca53656d61702f951f6c6b1318b8bd6e5d2a2390c063647128baa";
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
