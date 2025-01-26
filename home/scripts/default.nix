{ config, lib, pkgs, ... }:

let
  grimblast_watermark = pkgs.writeShellScriptBin "grimblast_watermark" ''
        FILE=$(date "+%Y-%m-%d"T"%H:%M:%S").png
    # Get the picture from maim
        grimblast --notify --cursor save area $HOME/Pictures/$FILE >> /dev/null 2>&1
    # add shadow, round corner, border and watermark
        # convert $HOME/Pictures/src.png \
        #   \( +clone -alpha extract \
        #   -draw 'fill black polygon 0,0 0,8 8,0 fill white circle 8,8 8,0' \
        #   \( +clone -flip \) -compose Multiply -composite \
        #   \( +clone -flop \) -compose Multiply -composite \
        #   \) -alpha off -compose CopyOpacity -composite $HOME/Pictures/output.png
    #
        # convert $HOME/Pictures/output.png -bordercolor none -border 20 \( +clone -background black -shadow 80x8+15+15 \) \
        #   +swap -background transparent -layers merge +repage $HOME/Pictures/$FILE
    #
    #    composite -gravity Southeast "${./watermark.png}" $HOME/Pictures/$FILE $HOME/Pictures/$FILE 
    #
        wl-copy < $HOME/Pictures/$FILE
    #   remove the other pictures
        # rm $HOME/Pictures/src.png $HOME/Pictures/output.png
  '';
  nix_opts = pkgs.writeShellScriptBin "nix_opts" ''
    NIX_DIR=$1  # Your flake directory
    CONFIG_PATH="$2"  # Get first argument

    if [[ -z "$CONFIG_PATH" ]]; then
      echo "Error: Please specify a config path (e.g., hardware.nvidia)"
      exit 1
    fi

    sudo nix eval \
      --extra-experimental-features 'nix-command flakes' \
      "$NIX_DIR#nixosConfigurations.$CONFIG_PATH" \
      || { echo "Failed to evaluate path: $CONFIG_PATH"; exit 1; }
  '';
in
{
  home.packages = with pkgs; [
    grimblast_watermark
    nix_opts
  ];
}
