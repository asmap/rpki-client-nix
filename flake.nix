{
  description = "RPKI Client";

  # To build the package, run "nix build" in the current directory.
  # This will build the rpki-client binary and put it in 'result/bin/'.

  inputs = {
    # We pin to a set nixpkgs version
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # A lib to help build packages for multiple target systems
    utils.url = "github:numtide/flake-utils";
    # The RPKI portable client source, pinned to a specific version
    rpki-client-src = {
      url = "github:rpki-client/rpki-client-portable/15554f28842d7d9e6cc31eab5f95e36053b42f35"; # v9.8
      flake = false;
    };
    # The openbsd shim of rpki-client-portable, which gets pulled into rpki-client at build time
    # Since Nix can't fetch external sources (or access the Internet) at build time, we pull it in explicitly.
    # See https://github.com/rpki-client/rpki-client-portable/blob/master/update.sh
    rpki-openbsd-src = {
      url = "github:rpki-client/rpki-client-openbsd/8aa0236d10a6c5e25fb282eb030069dae3d3abbe"; # v9.8
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
      packages.default = rpki-client;

      # To run locally without cloning this repo, create a `cachedir` locally to hold RPKI data.
      # Then run "nix run github:asmap/rpki-client-nix -- -d cachedir"
      apps.rpki-client = utils.lib.mkApp {drv = rpki-client;};
    });
}
