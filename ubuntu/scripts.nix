{ config, lib, pkgs, ... }:

let
  unittests = pkgs.writeShellScriptBin "unittests" ''
    make -C /home/$USER/Projects/check_mk/tests test-unit
  '';

  rgff = pkgs.writeShellScriptBin "rgff" ''
    fzf --ansi --disabled --phony \
      --bind "change:reload:rg --hidden --line-number --color=always {q} || true" \
      --prompt "RG> " \
      --header "Live ripgrep search (type to search, Enter to open)" \
      --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
      --delimiter : \
      --preview-window 'up:60%' | while IFS=: read -r file lineno _; do
        if [ -n "$file" ] && [ -n "$lineno" ]; then
          nvim +"$lineno" "$file"
        fi
      done
  '';
  rgf = pkgs.writeShellScriptBin "rgf" ''
    fd --type f --hidden --follow --exclude .git | \
      fzf --ansi --preview 'bat --style=numbers --color=always {}' \
          --preview-window 'right:60%' \
          --prompt "Files> " \
          --header "Fuzzy file finder (Enter to open)" | \
      while read -r file; do
        if [ -n "$file" ]; then
          nvim "$file"
        fi
      done
  '';
in
{
  home.packages = with pkgs; [
    unittests
    rgff
    rgf
    ];
}
