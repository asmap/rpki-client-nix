{
  pkgs ? import <nixpkgs> {}
}:
  with pkgs;
	let
		openbsd_src = fetchFromGitHub {
			owner = "rpki-client";
			repo = "rpki-client-openbsd";
			# rev = "c1363a74cc718dbbaee38488a8598cd1c26f74f0";
			rev = "rpki-client-8.2";
			hash = "sha256-oErUjZn/a/Ka70+Z8Wb2L7UIulGPjF81bYAQ2wPvWfo=";
		};
	in stdenv.mkDerivation rec {
		inherit openbsd_src;
		buildInputs = [ git libressl expat zlib automake autoconf git libtool ];
		name = "rpki-client";
		version = "8.2";
		src = fetchFromGitHub {
			owner = "rpki-client";
			repo = "rpki-client-portable";
			rev = version;
			hash = "sha256-oErUjZn/a/Ka70+Z8Wb2L7UIulGPjF81bYAQ2wPvWfo=";
		};
		unpackPhase = ''
			echo ${src}
			pwd
			mkdir -p openbsd
			cp -R ${openbsd_src}/* openbsd
			cp -R ${src}/* .
			chmod 700 -R .
			sed -i 's|dir=`pwd`|dir=${src}|g' openbsd/update.sh
		'';
		configurePhase = ''
			./autogen.sh
			${src}/configure --prefix=$out
		'';
		}
