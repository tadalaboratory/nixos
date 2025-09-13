{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {
      devShells."x86_64-linux".nodejs = pkgs.mkShell {
        buildInputs = [
          pkgs.nodejs
          pkgs.pnpm
          pkgs.yarn
          pkgs.git
        ];
      };
    };
}
