{ config, pkgs, ... }:

{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Include common options
    ../../common.nix
  ];
  networking.hostname = "fractal";

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
