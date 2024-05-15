{ config, lib, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      mako
    ];
  };
  home.file.".config/mako/config".text = ''
    # GLOBAL
    max-history=100
    sort=-time

    # BINDING OPTIONS
    on-button-left=dismiss
    on-button-middle=none
    on-button-right=dismiss-all
    on-touch=dismiss
    on-notify=exec mpv /usr/share/sounds/freedesktop/stereo/message.oga

    # STYLE OPTIONS
    font="CaskaydiaCove Nerd Font"
    width=300
    height=100
    margin=10
    padding=15
    border-size=2
    border-radius=10
    icons=1
    max-icon-size=48
    icon-location=left
    markup=1
    actions=1
    history=1
    text-alignment=center
    default-timeout=5000
    ignore-timeout=0
    max-visible=5
    layer=overlay
    anchor=top-right

    background-color=#1e1e2e
    text-color=#d9e0ee
    border-color=#313244
    progress-color=over #89b4fa

    [urgency=low]
    border-color=#313244
    default-timeout=2000

    [urgency=normal]
    border-color=#313244
    default-timeout=5000

    [urgency=high]
    border-color=#f38ba8
    text-color=#f38ba8
    default-timeout=0

    [category=mpd]
    border-color=#f9e2af
    default-timeout=2000
    group-by=category

  '';

  home.file.".config/mako/icons" = {
    source = ./icons;
    recursive = true;
  };
}
