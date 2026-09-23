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

  home.username = "lukas";
  home.homeDirectory = "/home/lukas";

  # Let Firefox video playback inhibit Sway's idle timer directly.
  # The GTK portal can report success without actually inhibiting idle on Sway.
  home.sessionVariables.MOZ_WAKE_LOCK_TYPE = "WaylandIdleInhibit";

  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    sway.enable = true;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };

  programs.swaylock = {
    enable = true;
    settings.color = "1e1e2e";
  };

  services.mako = {
    enable = true;
    settings.default-timeout = 5000;
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  services.easyeffects.enable = true;

  services.cliphist.enable = true;
  programs.fuzzel.enable = true;

  services.swayidle = {
    enable = true;
    # Wait for swaylock to acquire the lock before allowing sleep.
    extraArgs = [ "-w" ];
    timeouts = [
      {
        timeout = 600;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
      lock = "${pkgs.swaylock}/bin/swaylock -f";
    };
  };

  # Enable sway window manager
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";
      bars = [ ];
      keybindings = lib.mkOptionDefault {
        "${modifier}+l" = "exec ${pkgs.swaylock}/bin/swaylock -f";
        "${modifier}+Shift+v" = "exec ${lib.getExe clipboardHistory}";
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
          mode = "1920x1080";
          scale = "1.2";
        };
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      position = "bottom";
      height = 26;
      modules-left = [
        "sway/workspaces"
        "sway/mode"
      ];
      modules-right = [
        "pulseaudio"
        "network"
        "battery"
        "disk"
        "cpu"
        "memory"
        "clock"
        "tray"
      ];
      pulseaudio = {
        format = "Vol {volume}%";
        format-muted = "Muted";
        on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      network = {
        format-wifi = "Wi-Fi {essid} {signalStrength}%";
        format-ethernet = "LAN {ipaddr}";
        format-disconnected = "Offline";
      };
      battery = {
        format = "Bat {capacity}%";
        format-charging = "Bat {capacity}% +";
        states = {
          warning = 20;
          critical = 10;
        };
      };
      disk = {
        path = "/";
        format = "Disk {free}";
      };
      cpu.format = "CPU {usage}%";
      memory.format = "RAM {used:0.1f}G";
      clock = {
        format = "{:%Y-%m-%d %H:%M}";
        tooltip-format = "{:%A, %d %B %Y}";
      };
      tray = {
        icon-size = 20;
        spacing = 8;
      };
    };
    style = ''
      * { font-family: monospace; font-size: 12px; }
      window#waybar { background: #000000; color: #ffffff; }
      #workspaces button { padding: 0 6px; border-radius: 0; color: #ffffff; }
      #workspaces button.focused { background: #285577; }
      #workspaces button.urgent, #battery.critical { background: #900000; }
      #mode, #pulseaudio, #network, #battery, #disk, #cpu, #memory, #clock, #tray {
        padding: 0 8px;
      }
      #tray menu { background: #222222; color: #ffffff; }
      #tray menu menuitem:hover { background: #285577; }
    '';
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=12";
      };
    };
  };

  programs.firefox = {
    enable = true;
    # The UHD 620 lacks AV1 hardware decoding; software decoding stutters on live video.
    policies.Preferences."media.av1.enabled" = {
      Value = false;
      Status = "locked";
    };
  };

  programs.swayimg.enable = true;

  programs.mpv.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/mw-matlabconnector" = [ "mw-matlabconnector.desktop" ];
      "x-scheme-handler/mw-simulink" = [ "mw-simulink.desktop" ];
      "x-scheme-handler/mw-matlab" = [ "mw-matlab.desktop" ];
    };
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      nil
      nixfmt
      marksman
      prettier
    ];
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        cursorline = true;
        bufferline = "multiple";
        color-modes = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
      };
    };
    languages.language = [
      {
        name = "nix";
        language-servers = [ "nil" ];
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        auto-format = true;
      }
      {
        name = "markdown";
        language-servers = [ "marksman" ];
        formatter = {
          command = "${pkgs.prettier}/bin/prettier";
          args = [
            "--parser"
            "markdown"
            "--prose-wrap"
            "preserve"
          ];
        };
        auto-format = true;
        text-width = 80;
        soft-wrap = {
          enable = true;
          wrap-at-text-width = true;
        };
      }
    ];
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        ms-toolsai.jupyter
        tomoki1207.pdf
        catppuccin.catppuccin-vsc
        myriad-dreamin.tinymist
        ms-python.python
        ms-python.vscode-pylance
        jnoortheen.nix-ide
      ];
      userSettings = {
        "chat.disableAIFeatures" = true;
        "workbench.colorTheme" = "Catppuccin Mocha";
        "editor.lineNumbers" = "relative";
        "editor.renderLineHighlight" = "all";
        "editor.guides.indentation" = true;
        "editor.cursorStyle" = "line";
        "editor.minimap.enabled" = false;

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
        "nix.serverSettings".nil.formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
        };

        "tinymist.preview.refresh" = "onType";
        "[typst]" = {
          "editor.defaultFormatter" = "myriad-dreamin.tinymist";
          "editor.wordWrap" = "on";
        };

        "markdown.validate.enabled" = true;
        "[markdown]" = {
          "editor.wordWrap" = "bounded";
          "editor.wordWrapColumn" = 80;
        };
      };
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Lukas Ejvinsson";
        email = "lukas@ejvinsson.se";
      };
      init.defaultBranch = "main";
    };
  };

  programs.codex = {
    enable = true;
  };

  programs.fastfetch = {
    enable = true;
  };

  programs.zathura = {
    enable = true;
  };
  home.packages = with pkgs; [
    nextcloud-client
    qbittorrent
    gammastep
    xdg-utils
    wl-clipboard
    sway-contrib.grimshot
    playerctl
    qalculate-gtk
    libqalculate
    gnuplot
    (python3.withPackages (
      ps: with ps; [
        numpy
        matplotlib
      ]
    ))
  ];

  home.stateVersion = "26.05";

}
