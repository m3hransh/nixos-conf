{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    # the seting is not mutable
    keyMode = "vi";
    mouse = true;
    shortcut = "a";
    baseIndex = 1;
    escapeTime = 0;
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.yank
      tmuxPlugins.urlview
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''set -g @catppuccin_window_default_text "#W" # use "#{b:pane_current_path}" for directory instead of application'';
      }
    ];
    extraConfig = ''
      # Custom navigation and resizing (optional, for more vim-like feel)
      bind -N "Select pane to the left of the active pane" h select-pane -L
      bind -N "Select pane below the active pane" j select-pane -D
      bind -N "Select pane above the active pane" k select-pane -U
      bind -N "Select pane to the right of the active pane" l select-pane -R

      bind -r -N "Resize the pane left by 5" H resize-pane -L 5
      bind -r -N "Resize the pane down by 5" J resize-pane -D 5
      bind -r -N "Resize the pane up by 5" K resize-pane -U 5
      bind -r -N "Resize the pane right by 5" L resize-pane -R 5

      # Use vim-like copy mode (assuming you have a plugin like 'tmux-yank')
      bind-key -T copy-mode v send-keys "v"
    '';
  };
}
