#!/bin/sh
# Mandatory Prefix
echo "STARTUP-SCRIPT START"

# Env Var
export USER="nix-dev"
export HOME="/home/nix-dev"

# Create a user
useradd $USER -m -p Password01 -s /bin/bash -c "$USER Developer Account"`

# Install Nix package manager - Ensure $USER + $HOME are defined
sh <(curl -L https://nixos.org/nix/install) --daemon --yes

# Install required application packages - use full path for nix tooling
/nix/var/nix/profiles/default/bin/nix-env -iA nixpkgs.nodejs_22 nixpkgs.firebase-tools nixpkgs.cacert
# nix-env -iA nixpkgs.nodejs_22 nixpkgs.firebase-tools nixpkgs.cacert

# Mandatory Postfix
echo "STARTUP-SCRIPT END"
