{
  description = "RPKI Client v9.1";

  # To build the package, run "nix build" in the current directory.
  # This will build the rpki-client binary and put it in 'result/bin/'.

  inputs = {
    # We pin to a set nixpkgs version
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # A lib to help build packages for multiple target systems
    utils.url = "github:numtide/flake-utils";
    # The RPKI portable client source, pinned to a specific version
    rpki-client-src = {
      url = "github:rpki-client/rpki-client-portable/a8aadf11866008666e17c65da76132659942fe2c"; # v9.1
      flake = false;
    };
    # The openbsd shim of rpki-client-portable, which gets pulled into rpki-client at build time
    # Since Nix can't fetch external sources (or access the Internet) at build time, we pull it in explicitly.
    # See https://github.com/rpki-client/rpki-client-portable/blob/master/update.sh
    rpki-openbsd-src = {
      url = "github:rpki-client/rpki-client-openbsd/a59ae351b4f900cf90b01e755118290047fcdb28"; # v9.1
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    rpki-client-src,
    rpki-openbsd-src,
  }:
    # Read as: for each system, use nixpkgs and run the default.nix build instructions with these args.
    utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      rpki-client = import ./default.nix {inherit pkgs rpki-client-src rpki-openbsd-src;};
    in rec {
      # This exposes a package under the namespace rpki-client.defaultPackage.<system>
      defaultPackage = rpki-client;

      # To run locally without cloning this repo, create a `cachedir` locally to hold RPKI data.
      # Then run "nix run github:fjahr/rpki-client-nix -- -d cachedir"
      apps.rpki-client = utils.lib.mkApp {drv = rpki-client;};
    });
}
