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
				mode = "1920x1980";
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




 home.stateVersion = "26.05";

}
