#!/usr/bin/env bash
pushd ~/.config/nixos/
sudo nixos-rebuild switch --flake ./#mehran-rog
popd
