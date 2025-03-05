#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

export UV_NO_MODIFY_PATH=1

if type uv > /dev/null; then
    info "updating uv"
    uv self update
else
    info "installing uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
