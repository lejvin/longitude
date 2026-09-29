{
  description = "NixOS configuration";

  inputs = {
    stable.url = "github:nixos/nixpkgs/nixos-26.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs =
    {
      unstable,
      home-manager,
      nixos-hardware,
      ...
    }:
    {
      nixosConfigurations = {
        longitude = unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/longitude
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lukas = ./home.nix;
            }
          ];
        };
        fw = unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/fw
            nixos-hardware.nixosModules.framework-13-7040-amd
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lukas = {
                imports = [
                  ./home.nix
                  ./hosts/fw/home.nix
                ];
              };
            }
          ];
        };
      };
    };
}
