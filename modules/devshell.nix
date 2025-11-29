# modules/devshell.nix
{ lib, ... }:

{
  perSystem = { pkgs, self', ... }: {
    devShells.default = pkgs.mkShell {
      packages = [
        self'.packages.apm
        pkgs.python3
        pkgs.nodejs_24 # Added as per user request to update flake to use nodejs_24
      ];
      # Add any other development tools here
      # e.g., pkgs.black, pkgs.isort, pkgs.mypy, pkgs.pytest
    };
  };
}
