{ config, lib, pkgs, ... }:

{
    programs.waybar = {
      enable = true;
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
      style = ''
               * {
                 font-family: "JetBrainsMono Nerd Font";
                 font-size: 12pt;
                 font-weight: bold;
                 border-radius: 0px;
                 transition-property: background-color;
                 transition-duration: 0.5s;
               }
               @keyframes blink_red {
                 to {
                   background-color: rgb(242, 143, 173);
                   color: rgb(26, 24, 38);
                 }
               }
               .warning, .critical, .urgent {
                 animation-name: blink_red;
                 animation-duration: 1s;
                 animation-timing-function: linear;
                 animation-iteration-count: infinite;
                 animation-direction: alternate;
               }
               window#waybar {
                 background-color: transparent;
               }
               window > box {
                 margin-left: 5px;
                 margin-right: 5px;
                 margin-top: 5px;
                 background-color: rgb(30, 30, 46);
               }
         #workspaces {
                 padding-left: 0px;
                 padding-right: 4px;
               }
         #workspaces button {
                 padding-top: 5px;
                 padding-bottom: 5px;
                 padding-left: 6px;
                 padding-right: 6px;
               }
         #workspaces button.active {
                 background-color: rgb(181, 232, 224);
                 color: rgb(26, 24, 38);
               }
         #workspaces button.urgent {
                 color: rgb(26, 24, 38);
               }
         #workspaces button:hover {
                 background-color: rgb(248, 189, 150);
                 color: rgb(26, 24, 38);
               }
               tooltip {
                 background: rgb(48, 45, 65);
               }
               tooltip label {
                 color: rgb(217, 224, 238);
               }
         #custom-launcher {
                 font-size: 20px;
                 padding-left: 8px;
                 padding-right: 6px;
                 color: #7ebae4;
               }
         #mode, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #backlight, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
                 padding-left: 10px;
                 padding-right: 10px;
               }
               /* #mode { */
               /* 	margin-left: 10px; */
               /* 	background-color: rgb(248, 189, 150); */
               /*     color: rgb(26, 24, 38); */
               /* } */
         #memory {
                 color: rgb(181, 232, 224);
               }
         #cpu {
                 color: rgb(245, 194, 231);
               }
         #clock {
                 color: rgb(217, 224, 238);
               }
        /* #idle_inhibitor {
                 color: rgb(221, 182, 242);
               }*/
         #custom-wall {
                 color: rgb(221, 182, 242);
            }
         #temperature {
                 color: rgb(150, 205, 251);
               }
         #backlight {
                 color: rgb(248, 189, 150);
               }
         #pulseaudio {
                 color: rgb(245, 224, 220);
               }
         #network {
                 color: #ABE9B3;
               }

         #network.disconnected {
                 color: rgb(255, 255, 255);
               }
         #battery.charging, #battery.full, #battery.discharging {
                 color: rgb(250, 227, 176);
               }
         #battery.critical:not(.charging) {
                 color: rgb(242, 143, 173);
               }
         #custom-powermenu {
                 color: rgb(242, 143, 173);
               }
         #tray {
                 padding-right: 8px;
                 padding-left: 10px;
               }
         #mpd.paused {
                 color: #414868;
                 font-style: italic;
               }
         #mpd.stopped {
                 background: transparent;
               }
         #mpd {
                 color: #c0caf5;
               }
         #custom-cava-internal{
                 font-family: "Hack Nerd Font" ;
               }
      '';
      settings = [{



  "modules-left"= ["sway/workspaces" "custom/media"];


  "sway/workspaces"= {
     "disable-scroll"= true;
     "all-outputs"= false;
     "format"= "{icon}";
     "format-icons"= {
       "1"= "";
       "2"= "";
       "3"= "";
       "4"= "";
       "5"= "";
       "6"= "";
       "7"= "";
       "8"= "";
       "9"= "";
       "10"= "";
       "urgent"= "";
       "focused"= "";
       "default"= "";
     };
   };
 


"custom/media"= {
    "format"= "<span color='#9ece6a'> </span>{icon} {}";
    "escape"= true;
    "return-type"= "json";
    "max-length"= 30;
    "on-click"= "playerctl -p spotify play-pause";
    "on-click-right"= "killall spotify";
    # This value was tested using a trackpad; it should be lowered if using a mouse.
    "smooth-scrolling-threshold"= 2; 
    "on-scroll-up"= "playerctl -p spotify next";
    "on-scroll-down"= "playerctl -p spotify previous";
    # Script in resources/custom_modules folder
    "exec"= "$HOME/.scripts/mediaplayer.py --player spotify 2> /dev/null"; 
    "exec-if"= "pgrep spotify";
};


  "modules-center"= ["custom/github" "custom/scratchpad-indicator" "cpu" "custom/memory" "custom/disk_root" "temperature" "clock" "idle_inhibitor" "sway/language" "custom/notification"];

"custom/github"= {
    "format" = "{} ";
    "return-type" = "json";
    "interval" = 60;
    "exec" = "$HOME/.config/waybar/custom_modules/github.sh";
    "on-click" = "xdg-open https://github.com/notifications";
};

  "custom/scratchpad-indicator" = {
    "interval" = 3;
    "return-type" = "json";
    "exec" = "swaymsg -t get_tree | jq --unbuffered --compact-output '(recurse(.nodes[]) | select(.name == \"__i3_scratch\") | .focus) as $scratch_ids | [..  | (.nodes? + .floating_nodes?) // empty | .[] | select(.id |IN($scratch_ids[]))] as $scratch_nodes | if ($scratch_nodes|length) > 0 then { text: \"\\($scratch_nodes | length)\", tooltip: $scratch_nodes | map(\"\\(.app_id // .window_properties.class) (\\(.id)): \\(.name)\") | join(\"\\n\") } else empty end'";
    "format" = "{} <span color='#2ac3de'></span> ";
    "on-click" = "exec swaymsg 'scratchpad show'";
    "on-click-right" = "exec swaymsg 'move scratchpad'";
};


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
    "format-icons" = [""];
  };

  "clock"= {
    "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    "format-alt" = "{:%Y-%m-%d}";
    "format-alt-click" = "click-left";
    "interval" = 60;
    "format" = "{:%H:%M} <span color='#bb9af7'></span>";
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

  "sway/language" = {
      "format"= "{shortDescription}";
      };


  "idle_inhibitor" = {
      "format" = "{icon}";
      "on-click" = "/home/m3d/.scripts/sunset";
      "format-icons" = {
        "activated" = "";
        "deactivated" = "";
      };
    };

  "modules-right" = [ "tray" "network#wifi"   "pulseaudio" "backlight"  "battery"  "custom/power"];
    "tray" = {
        "icon-size" = 15;
        "spacing" = 10;
    };

"network#wifi"= {
    "interval"= 30 ;
    "interface"= "wlp*" ;
    "format"= "{ifname}" ;
    "format-wifi"= "<span color='#9ece6a'> </span>{bandwidthDownBits} <span color='#73daca'> </span>{bandwidthUpBits}" ;
    "format-ethernet"= "<span color='#9ece6a'> </span>{bandwidthDownBits} <span color='#73daca'> </span>{bandwidthUpBits}" ;
    "format-disconnected"= "{ifname}" ; 
    "tooltip-format"= "{ifname} via {gwaddr} " ;
    "tooltip-format-wifi"= "{essid} ({signalStrength}%) " ;
    "tooltip-format-ethernet"= "{ifname} " ;
    "tooltip-format-disconnected"= "Disconnected" ;
    "max-length"= 50;
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
      "hands-free" = "" ;
      "headset" = "" ;
      "phone" = "" ;
      "portable" = "" ;
      "car" = "" ;
      "default" = ["" "" ""];
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
    "format-icons" = ["" ""];
  };
  


  "custom/power" = {
    "format" = "";
    "on-click" = "swaynag -t warning -m 'Power Menu Options' -b 'Logout' 'swaymsg exit' -b 'Restart' 'shutdown -r now' -b 'Shutdown'  'shutdown -h now' --background=#005566 --button-background=#009999 --button-border=#002b33 --border-bottom=#002b33";
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
    "format-icons" = ["" "" "" "" ""];
  };

      }];
    };
  # other config & style 

  home.file.".config/waybar/nord_style.css".text = ''
          * {
            font-family: "JetBrainsMono Nerd Font";
            font-size: 12pt;
            font-weight: bold;
            border-radius: 0px;
            transition-property: background-color;
            transition-duration: 0.5s;
          }
          @keyframes blink_red {
            to {
              background-color: rgb(242, 143, 173);
              color: rgb(26, 24, 38);
            }
          }
          .warning, .critical, .urgent {
            animation-name: blink_red;
            animation-duration: 1s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }
          window#waybar {
            background-color: transparent;
          }
          window > box {
            margin-left: 5px;
            margin-right: 5px;
            margin-top: 5px;
            background-color: #3b4252;
          }
    #workspaces {
            padding-left: 0px;
            padding-right: 4px;
          }
    #workspaces button {
            padding-top: 5px;
            padding-bottom: 5px;
            padding-left: 6px;
            padding-right: 6px;
            color:#D8DEE9;
          }
    #workspaces button.active {
            background-color: rgb(181, 232, 224);
            color: rgb(26, 24, 38);
          }
    #workspaces button.urgent {
            color: rgb(26, 24, 38);
          }
    #workspaces button:hover {
            background-color: #B38DAC;
            color: rgb(26, 24, 38);
          }
          tooltip {
            /* background: rgb(250, 244, 252); */
            background: #3b4253;
          }
          tooltip label {
            color: #E4E8EF;
          }
    #custom-launcher {
            font-size: 20px;
            padding-left: 8px;
            padding-right: 6px;
            color: #7ebae4;
          }
    #mode, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #backlight, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
            padding-left: 10px;
            padding-right: 10px;
          }
          /* #mode { */
          /* 	margin-left: 10px; */
          /* 	background-color: rgb(248, 189, 150); */
          /*     color: rgb(26, 24, 38); */
          /* } */
    #memory {
            color: #8EBBBA;
          }
    #cpu {
            color: #B38DAC;
          }
    #clock {
            color: #E4E8EF;
          }
    /*
    #idle_inhibitor {
    color: #FF6699;
    }*/
    #custom-wall {
            color: #B38DAC;
          }
    #temperature {
            color: #80A0C0;
          }
    #backlight {
            color: #A2BD8B;
          }
    #pulseaudio {
            color: #E9C98A;
          }
    #network {
            color: #99CC99;
          }

    #network.disconnected {
            color: #CCCCCC;
          }
    #battery.charging, #battery.full, #battery.discharging {
            color: #CF876F;
          }
    #battery.critical:not(.charging) {
            color: #D6DCE7;
          }
    #custom-powermenu {
            color: #BD6069;
          }
    #tray {
            padding-right: 8px;
            padding-left: 10px;
          }
    #tray menu {
            background: #3b4252;
            color: #DEE2EA;
    }
    #mpd.paused {
            color: rgb(192, 202, 245);
            font-style: italic;
          }
    #mpd.stopped {
            background: transparent;
          }
    #mpd {
              color: #E4E8EF;

            /* color: #c0caf5; */
          }
    #custom-cava-internal{
            font-family: "Hack Nerd Font" ;
          }
  '';
}
