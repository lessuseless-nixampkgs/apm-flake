# modules/devshell.nix
{ lib, ... }:

{
  perSystem = { pkgs, self', ... }: {
    devShells.default = pkgs.mkShell {
      packages = [
        self'.packages.apm
        pkgs.python3
      ];
      # Add any other development tools here
      # e.g., pkgs.black, pkgs.isort, pkgs.mypy, pkgs.pytest
    };
  };
}
