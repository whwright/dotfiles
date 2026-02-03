#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

if type starship > /dev/null; then
    skipped "starship already installed"
    exit 0
fi

curl -sS https://starship.rs/install.sh | sh

