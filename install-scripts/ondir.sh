#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

if type ondir > /dev/null; then
    skipped "ondir already installed"
    exit 0
fi

pushd zsh/ondir.symlink
mkdir -p "${HOME}/.local/bin"
mkdir -p "${HOME}/.local/etc"
make PREFIX="${HOME}/.local" CONF="${HOME}/.local/etc/ondirrc" install
popd
