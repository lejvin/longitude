{
  config,
  pkgs,
  lib,
  ...
}:

{
  wayland.windowManager.sway.config = {
    output."eDP-1".scale = "2";
    bars = [
      {
        position = "top";
        statusCommand = lib.getExe pkgs.i3status;
      }
    ];
  };
}
