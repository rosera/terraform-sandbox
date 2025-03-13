{
  startup-script = <<EOF
    #!/bin/bash
    # STARTUP-START
    # Update package lists and install required packages
    # Env Var
    export USER="nix-dev"
    export HOME="/home/$USER"

    # Create a user
    useradd $USER -m -p Password01 -s /bin/bash -c "$USER Developer Account"

    # Install Nix package manager - Ensure $USER + $HOME env var are defined
    sh <(curl -L https://nixos.org/nix/install) --daemon --yes

    # Install required application packages
    /nix/var/nix/profiles/default/bin/nix-env -iA nixpkgs.nodejs_22 nixpkgs.firebase-tools nixpkgs.cacert
    # nix-env -iA nixpkgs.nodejs_22 nixpkgs.firebase-tools nixpkgs.cacert
  EOF
}
