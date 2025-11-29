# modules/apps.nix
{ lib, ... }:

{
  perSystem =
    { pkgs, self', ... }:
    {
      apps.default = {
        type = "app";
        program = "${self'.packages.apm}/bin/apm";
        meta.description = "Agent Package Manager - CLI tool for managing AI agent packages";
      };
    };
}
