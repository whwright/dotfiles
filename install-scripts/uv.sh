#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

if type ondir > /dev/null; then
    info "updating uv"
    uv self update
else
    info "installing uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
