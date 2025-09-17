{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nur,
      vscode-server,
      treefmt-nix,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    rec {
      treefmtEval = treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          prettier.enable = true;
        };
      };
      formatter."${system}" = treefmtEval.config.build.wrapper;
      nixosConfigurations = nixpkgs.lib.mapAttrs (
        host: _:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            {
              nixpkgs.overlays = [
                (final: _: {
                  unstable = import nixpkgs-unstable {
                    inherit (final.stdenv.hostPlatform) system;
                    inherit (final) config;
                  };
                })
              ];
            }
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [ nur.overlays.default ];
            }
            vscode-server.nixosModules.default
            {
              services.vscode-server.enable = true;
            }
            ./hosts/${host}/configuration.nix
          ]
          ++ map (user: ./hosts/${host}/users/${user}) (
            builtins.attrNames (
              nixpkgs.lib.filterAttrs (name: type: type == "directory" && builtins.substring 0 1 name != ".") (
                builtins.readDir ./hosts/${host}/users
              )
            )
          );
        }
      ) (nixpkgs.lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./hosts));
    };
}
