{ config, lib, pkgs, ... }:

{
  home.file.".config/waybar/custom_modules" = {
    source = ./custom_modules;
    recursive = true;
  };

  programs = {
    bash = {
      initExtra = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
           exec  Hyprland
        fi
      '';
    };
    fish = {
      loginShellInit = ''
        set TTY1 (tty)
        [ "$TTY1" = "/dev/tty1" ] && exec Hyprland
      '';
    };
  };
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    style = builtins.readFile ./style.css;
    settings = [{


      "layer" = "top";
      "modules-left" = [ "hyprland/workspaces" "hyprland/window" ];


      "hyprland/workspaces" = {
        "on-scroll-up" = "hyprctl dispatch workspace e+1";
        "on-scroll-down" = "hyprctl dispatch workspace e-1";
        "format" = "{icon}";
        "format-icons" = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          "6" = "";
          "7" = "";
          "8" = "";
          "9" = "";
          "urgent" = "";
          "focused" = "";
          "default" = "";
        };
      };

      "hyprland/window" = {
        format = "<span color='#ff9e64'>{}</span>";
        icon = true;
        separate-outputs = true;
        icon-size = 15;
      };



      "custom/media" = {
        "format" = "<span color='#9ece6a'> </span>{icon} {}";
        "escape" = true;
        "return-type" = "json";
        "max-length" = 30;
        "on-click" = "playerctl -p spotify play-pause";
        "on-click-right" = "killall spotify";
        # This value was tested using a trackpad; it should be lowered if using a mouse.
        "smooth-scrolling-threshold" = 2;
        "on-scroll-up" = "playerctl -p spotify next";
        "on-scroll-down" = "playerctl -p spotify previous";
        # Script in resources/custom_modules folder
        "exec" = "$HOME/.scripts/mediaplayer.py --player spotify 2> /dev/null";
        "exec-if" = "pgrep spotify";
      };


      "modules-center" = [ "custom/github" "cpu" "custom/memory" "custom/nvidia" "custom/disk_root" "temperature" "clock" "hyprland/language" "custom/sunset" ];

      "custom/github" = {
        "format" = "{} ";
        "return-type" = "json";
        "interval" = 60;
        "exec" = "$HOME/.config/waybar/custom_modules/github.sh";
        "on-click" = "xdg-open https://github.com/notifications";
      };

      #   "custom/scratchpad-indicator" = {
      #     "interval" = 3;
      #     "return-type" = "json";
      #     "exec" = "swaymsg -t get_tree | jq --unbuffered --compact-output '(recurse(.nodes[]) | select(.name == \"__i3_scratch\") | .focus) as $scratch_ids | [..  | (.nodes? + .floating_nodes?) // empty | .[] | select(.id |IN($scratch_ids[]))] as $scratch_nodes | if ($scratch_nodes|length) > 0 then { text: \"\\($scratch_nodes | length)\", tooltip: $scratch_nodes | map(\"\\(.app_id // .window_properties.class) (\\(.id)): \\(.name)\") | join(\"\\n\") } else empty end'";
      #     "format" = "{} <span color='#2ac3de'></span> ";
      #     "on-click" = "exec swaymsg 'scratchpad show'";
      #     "on-click-right" = "exec swaymsg 'move scratchpad'";
      # };


      "cpu" = {
        "interval" = 5;
        "format" = "{usage}% <span color='#ff9e64'></span>";
      };


      "custom/memory" = {
        "format" = " {} <span color='#2ac3de'></span>";
        "return-type" = "json";
        "interval" = 5;
        "exec" = "$HOME/.config/waybar/custom_modules/memory.sh";
        "tooltip" = "used";
      };

      "custom/nvidia" = {
        "exec" = "nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,nounits,noheader | sed 's/\\([0-9]\\+\\), \\([0-9]\\+\\)/\\1% 🌡️\\2°C/g'";
        "format" = "{} 🖥️";
        "interval" = 2;
      };

      "custom/disk_root" = {
        "format" = " {}<span color='#e0af68'>  </span>";
        "interval" = 3600;
        "exec" = "df -h --output=avail / | tail -1 | tr -d ' '";
        "tooltip" = "false";
      };
      "temperature" = {
        "hwmon-path" = "/sys/class/hwmon/hwmon3/temp1_input";
        "critical-threshold" = 82;
        "format-critical" = "{temperatureC}°C {icon}";
        "format" = " {icon}";
        "format-alt" = " {temperatureC}°C {icon}";
        "format-alt-click" = "click-left";
        "format-icons" = [ "" ];
      };

      "clock" = {
        "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        "format-alt" = "{:%Y-%m-%d}";
        "format-alt-click" = "click-left";
        "interval" = 60;
        "format" = "{:%H:%M} <span color='#bb9af7'> </span>";
        "max-length" = 25;
        "on-click" = "gnome-calendar";
      };


      "custom/notification" = {
        "tooltip" = false;
        "format" = "{icon}";
        "format-icons" = {
          "notification" = "<span foreground='red'><sup></sup></span>";
          "none" = "";
          "dnd-notification" = "<span foreground='red'><sup></sup></span>";
          "dnd-none" = "";
        };
        "return-type" = "json";
        "exec-if" = "which swaync-client";
        "exec" = "swaync-client -swb";
        "on-click" = "swaync-client -t -sw";
        "on-click-right" = "swaync-client -d -sw";
        "escape" = true;
      };

      "hyprland/language" = {
        "format" = "{shortDescription}";
      };


      "custom/sunset" = {
        "format" = "<span color='#f7768e'>{}</span>";
        "exec" = "$HOME/.config/waybar/custom_modules/sunset.sh";
        "on-click" = "$HOME/.config/waybar/custom_modules/sunset-toggle.sh";
        "return-type" = "json";
        "restart-interval" = 1;
      };

      "modules-right" = [ "tray" "network#wifi" "pulseaudio" "backlight" "battery" "custom/power" ];
      "tray" = {
        "icon-size" = 15;
        "spacing" = 10;
      };

      "network#wifi" = {
        "interval" = 30;
        "interface" = "wlp*";
        "format" = "{ifname}";
        "format-wifi" = "<span color='#9ece6a'> </span>{bandwidthDownBits} <span color='#73daca'> </span>{bandwidthUpBits}";
        "format-ethernet" = "<span color='#9ece6a'> </span>{bandwidthDownBits} <span color='#73daca'> </span>{bandwidthUpBits}";
        "format-disconnected" = "{ifname}";
        "tooltip-format" = "{ifname} via {gwaddr} ";
        "tooltip-format-wifi" = "{essid} ({signalStrength}%) ";
        "tooltip-format-ethernet" = "{ifname} ";
        "tooltip-format-disconnected" = "Disconnected";
        "max-length" = 50;
        "on-click" = "exec kitty 'nmtui'";
      };

      "pulseaudio" = {
        "scroll-step" = 5;
        "format" = "{volume}% <span color='#f7768e'>{icon}</span> {format_source}";
        "format-bluetooth" = "{volume}% {icon} {format_source}";
        "format-bluetooth-muted" = " {icon} {format_source}";
        "format-muted" = " {format_source}";
        "format-source" = "{volume}% <span color='#f7768e'></span>";
        "format-source-muted" = "";
        "states" = {
          "high" = 70;
          "medium" = 50;
          "low" = 25;
          "mute" = 0;
        };
        "format-icons" = {
          "hands-free" = "";
          "headset" = "";
          "phone" = "";
          "portable" = "";
          "car" = "";
          "default" = [ "" "" "" ];
        };
        "on-click-right" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "on-click-middle" = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "on-click" = "pavucontrol";
      };



      "backlight" = {
        "device" = "intel_backlight";
        "format" = "{icon}";
        "format-alt" = "{percent}% {icon}";
        "format-alt-click" = "click-left";
        "on-scroll-up" = "light -A 5";
        "on-scroll-down" = "light -U 5";
        "format-icons" = [ "" "" ];
      };



      "custom/power" = {
        "format" = "";
        "on-click" = "sleep 0.1 && $HOME/.config/waybar/custom_modules/powermenu.sh";
      };



      "battery" = {
        "states" = {
          "good" = 100;
          "warning" = 30;
          "critical" = 15;
        };
        "format" = "{icon}";
        "format-alt" = "{capacity}% {icon}";
        "format-alt-click" = "click-left";
        "format-charging" = "{capacity}% ";
        "format-plugged" = "{capacity}% ";
        "format-full" = "{icon}";
        "format-icons" = [ "" "" "" "" "" ];
      };

    }];
  };

}
