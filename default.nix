{
  pkgs ? import <nixpkgs> { } ,
  rpki-client-src,
  rpki-openbsd-src,
}:
# build the package
pkgs.stdenv.mkDerivation rec {
  name = "rpki-client";
  version = "8.6";

  src = rpki-client-src;

  # Dependencies required at build time
  buildInputs = with pkgs; [
    libressl
    expat
    automake
    autoconf
    libtool
    rsync
    zlib
  ];

  # Prepare the source directory before configuring and building.
  # In this case, we set up the openbsd directory, which rpki-client-portable expects,
  # with the rpki-openbsd-src attribute we set up as a flake input.
  unpackPhase = ''
    mkdir -p openbsd
    cp -R ${rpki-openbsd-src}/* openbsd
    cp -R ${src}/* .
    chmod 700 -R .
  '';

  # Configure with the given scripts, but point to our nix-specific $out directory
  configurePhase = ''
    ./autogen.sh
    ./configure --prefix=$out
  '';

  # The default buildPhase for stdenv.mkDerivation is "make"
  # which is what the project wants in this case.
  # So we don't need to modify the buildPhase.
}
