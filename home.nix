{ config, pkgs, lib,  ...}:

{

 home.username = "lukas";
 home.homeDirectory = "/home/lukas";
 

 # Enable sway window manager
 wayland.windowManager.sway = {
	enable = true;
	wrapperFeatures.gtk = true;
	config = rec {
		modifier = "Mod4";
		keybindings = lib.mkOptionDefault {
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
		};
		output = {
			"*" = {
				bg = "${./wallpaper.png} fill";
			};
			"eDP-1" = {
				mode = "1920x1080";
				scale = "1.1";
			};
		};
	};
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
};

programs.helix = {
	enable = true;
	defaultEditor = true;
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


home.packages = with pkgs; [
	wl-clipboard
	cliphist
	playerctl
];

 home.stateVersion = "26.05";

}
