{ pkgs, lib, ... }:

{

  programs.thunderbird = {
    enable = true;
    languagePacks = [
      "en-US"
      "sv-SE"
    ];

  };
}
