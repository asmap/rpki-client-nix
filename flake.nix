{
  description = "RPKI Client v8.6";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    utils.url = "github:numtide/flake-utils";
    rpki-client-src = {
      url = "github:rpki-client/rpki-client-portable/aa554ab91add82bb68de00d323e02c9d20621aee"; # v8.6
      flake = false;
    };
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
    utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      rpki-client = import ./default.nix {inherit pkgs rpki-client-src rpki-openbsd-src;};
    in rec {
      defaultPackage = rpki-client;

      # Run without cloning, must create a `cachedir` first to host fetched data
      # nix run .# -- -d cachedir
      apps.rpki-client = utils.lib.mkApp {drv = rpki-client;};
    });
}
