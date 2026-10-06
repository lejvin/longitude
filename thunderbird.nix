{ pkgs, lib, ... }:

{

  programs.thunderbird = {
    enable = true;
    languagePacks = [
      "en-US"
      "sv-SE"
    ];

  };

  xdg.autostart = {
    enable = true;
    entries = [ "${pkgs.thunderbird}/share/applications/thunderbird.desktop" ];
  };
}
