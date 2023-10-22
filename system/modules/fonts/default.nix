{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    inconsolata
    (nerdfonts.override { fonts = [ "FiraCode" "CascadiaCode" "Iosevka" "IosevkaTerm" "JetBrainsMono"];} )
  ];

}
