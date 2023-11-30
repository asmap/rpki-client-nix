#!/usr/bin/env bash

# Pass a version to this script to run an older version of the RPKI client.
# Usage: sh build-with-version.sh 8.5
# Version must be a valid version in `versions.nix``

# Exit on error
set -e

# Check if the version argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 VERSION"
    exit 1
fi

VERSION="$1"

overrides=$(nix-instantiate --eval --expr "(import ./versions.nix { version = \"$VERSION\"; })"  | tr -d '"')

nix build .# $overrides