# modules/apps.nix
{ lib, ... }:

{
  perSystem = { pkgs, self', ... }: {
    apps.default = {
      type = "app";
      program = "${self'.packages.apm}/bin/apm";
    };
  };
}
