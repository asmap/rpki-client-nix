{
  description = "RPKI Client v8.6";

  # To build the package, run "nix build" in the current directory.
  # This will build the rpki-client binary and put it in 'result/bin/'.

  inputs = {
    # We pin to a set nixpkgs version
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    # A lib to help build packages for multiple target systems
    utils.url = "github:numtide/flake-utils";
    # The RPKI portable client source, pinned to a specific version
    rpki-client-src = {
      url = "github:rpki-client/rpki-client-portable/aa554ab91add82bb68de00d323e02c9d20621aee"; # v8.6
      flake = false;
    };
    # The openbsd shim of rpki-client-portable, which gets pulled into rpki-client at build time
    # Since Nix can't fetch external sources (or access the Internet) at build time, we pull it in explicitly.
    # See https://github.com/rpki-client/rpki-client-portable/blob/master/update.sh
    rpki-openbsd-src = {
      url = "github:rpki-client/rpki-client-openbsd/082ed00f2b1f8b1b578b2bc9eae84a5fc1923d68"; # v8.6
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
