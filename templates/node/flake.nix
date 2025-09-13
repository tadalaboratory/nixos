{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      getNodeShell =
        nodePkg:
        pkgs.mkShell {
          buildInputs = [
            nodePkg
            pkgs.pnpm
            pkgs.yarn
            pkgs.git
          ];
        };
    in
    {
      devShells."x86_64-linux" = {
        "node20" = getNodeShell pkgs.nodejs_20;
        "node22" = getNodeShell pkgs.nodejs_22;
        "nodejs" = getNodeShell pkgs.nodejs;
      };
    };
}
