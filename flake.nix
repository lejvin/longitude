{
  description = "NixOS configuration";

  inputs = {
    stable.url = "github:nixos/nixpkgs/nixos-26.05";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "unstable";
  };

  outputs =
    { unstable, home-manager, ... }:
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
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lukas = ./home.nix;
            }
          ];
        };
      };
    };
}
