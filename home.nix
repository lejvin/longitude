{ config, pkgs, ...}:

{

 home.username = "lukas";
 home.homeDirectory = "/home/lukas";
 

 # Enable sway window manager
 wayland.windowManager.sway = {
	enable = true;
	wrapperFeatures.gtk = true;
	config = rec {
		modifier = "Mod4";
		terminal = "foot";
		input = {
			"*" = {
				xkb_layout = "se";
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
