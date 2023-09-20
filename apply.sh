#!/usr/bin/env bash
pushd ~/dotfiles/nixos/
sudo nixos-rebuild switch --flake ./#mehran-rog
popd
