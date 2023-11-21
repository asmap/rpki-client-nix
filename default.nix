{
  pkgs,
  rpki-client-src,
  rpki-openbsd-src,
}:
pkgs.stdenv.mkDerivation rec {
  name = "rpki-client";
  version = "8.6";

  src = rpki-client-src;

  buildInputs = with pkgs; [
    libressl
    expat
    automake
    autoconf
    libtool
    rsync
    zlib
  ];

  unpackPhase = ''
    mkdir -p openbsd
    cp -R ${rpki-openbsd-src}/* openbsd
    cp -R ${src}/* .
    chmod 700 -R .
  '';

  configurePhase = ''
    ./autogen.sh
    ./configure --prefix=$out
  '';
}
