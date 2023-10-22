# My NixOS Configuration

This repository hosts my personal NixOS configuration managed using flakes.
![preview](image.png)
## Overview
These are main files of configuration.
[flake.nix](./flake.nixy) is the entry point where you specify the inputs
and load two main modules namely [configuration.nix](./system/configuration.nix) and
[home.nix](./home/home.nix).
**home** folder contains packages that aren't related to the system. **home/programs** modularizes
some main packages that contain extra configs (e.g. nvim) beside their config files.

```bash
├── apply.sh
├── flake.lock
├── flake.nix
├── README.md
├── system
│   ├── configuration.nix # main system modules that import others and set up general conf
│   ├── hardware-configuration.nix # this might change depending on your machine spec
│   └── modules
│       ├── fonts # specify the font packages
│       ├── locale # time and locale settings
│       ├── networking # all network related services
│       ├── programs # system level packages and programs 
│       ├── services # general system level services
│       └── wm
│           └── hyprland # services and packages related to hyprland
└─ home
    ├── home.nix # home manager module where imports other programs
    ├── programs
    │   ├── default.nix
    │   ├── dunst
    │   ├── hypr
    │   ├── imageview
    │   ├── kooha
    │   ├── mpv
    │   ├── music
    │   ├── nvim
    │   ├── obs-studio
    │   ├── ranger
    │   ├── resource_monitor
    │   ├── search
    │   ├── vscode
    │   ├── waybar
    │   ├── wofi
    │   ├── youtube-tui
    │   ├── yt-dlp
    │   └── zathura
    └── scripts
```
## Prerequisites

- NixOS
- Flakes feature enabled

## Usage
Make sure [hardware-configuration.nix](./system/hardware-configuration.nix) reflects your machine specs. Then open [flake.nix](./flake.nix) and change **user** and **hostName** variable to your liking.
```nix
 ...
  let
      system = "x86_64-linux";
      user = "mehran";
      hostName = "mehran-rog";
    in {

      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem rec{
  ...
```
By issuing following command you will have the config in your system.
```bash
nixos-rebuild switch --flake '.#yourhostname'

```
## Inspirations
- [Ruixi-rebirth/flakes](https://github.com/Ruixi-rebirth/flakes.git)
- [HeinzDev/Hyprland-dotfiles](https://github.com/HeinzDev/Hyprland-dotfiles.git)