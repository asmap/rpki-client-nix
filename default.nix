{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation rec {
  name = "rpki-client";
  version = "8.2";

  src = pkgs.fetchFromGitHub {
    owner = "rpki-client";
    repo = "rpki-client-portable";
    rev = version;
    hash = "sha256-oErUjZn/a/Ka70+Z8Wb2L7UIulGPjF81bYAQ2wPvWfo=";
  };

  openbsd_src = pkgs.fetchFromGitHub {
    owner = "rpki-client";
    repo = "rpki-client-openbsd";
    rev = "rpki-client-8.2";
    hash = "sha256-zC3vbQLLWgImS+lYNWbHzkLrZTJvgPfH+W+FiSnH8Aw=";
  };

  buildInputs = with pkgs; [
    libressl
    expat
    automake
    autoconf
    libtool
    rsync
  ];

  unpackPhase = ''
    mkdir -p openbsd
    cp -R ${openbsd_src}/* openbsd
    cp -R ${src}/* .
    chmod 700 -R .
  '';

  configurePhase = ''
    ./autogen.sh
    ./configure --prefix=$out
  '';
}
