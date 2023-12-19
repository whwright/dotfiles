#!/usr/bin/env bash

set -o errexit
source lib.sh

if [ -f /usr/local/bin/ondir ]; then
    info "ondir already installed"
    exit 0
fi

sudo make PREFIX=/usr/local CONF=/usr/local/etc/ondirrc install
