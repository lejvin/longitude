{ pkgs, lib, ... }:
let
  clipboardHistory = pkgs.writeShellApplication {
    name = "clipboard-history";
    runtimeInputs = with pkgs; [
      cliphist
      fuzzel
      wl-clipboard
    ];
    text = ''
      if ! selection="$(cliphist list | fuzzel --dmenu --prompt 'Clipboard: ')"; then
        exit 0
      fi
      if [[ -n "$selection" ]]; then
        printf '%s\n' "$selection" | cliphist decode | wl-copy
      fi
    '';
  };
in
{
  # Enable sway window manager
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraConfig = ''
      popup_during_fullscreen smart
    '';
    config = rec {
      modifier = "Mod4";
      bars = [ ];
      keybindings = lib.mkOptionDefault {
        "${modifier}+l" = "exec ${pkgs.swaylock}/bin/swaylock -f";
        "${modifier}+Shift+v" = "exec ${lib.getExe clipboardHistory}";
        "${modifier}+d" = "exec ${lib.getExe pkgs.fuzzel}";
        "Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify copy area";
        "Shift+Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify copy screen";
        "${modifier}+Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify copy active";
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        "XF86AudioStop" = "exec ${pkgs.playerctl}/bin/playerctl stop";
      };
      window = {
        titlebar = false;
      };
      terminal = "foot";
      input = {
        "*" = {
          xkb_layout = "se";
        };
        "type:touchpad" = {
          natural_scroll = "enabled";
        };
      };
      output = {
        "*" = {
          bg = "${./wallpaper.jpg} fill";
        };
        "eDP-1" = {
          scale = lib.mkDefault "1.25";
        };
      };
    };
  };
}
