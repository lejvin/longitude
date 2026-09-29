{
  config,
  pkgs,
  lib,
  ...
}:

{
  wayland.windowManager.sway.config = {
    output."eDP-1".scale = "2";
  };
}
