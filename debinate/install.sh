#!/usr/bin/env bash

set -o errexit
source lib.sh

DEST=/usr/local/bin/debinate

if [ -f ${DEST} ]; then
    info "debinate already installed"
    exit 0
fi

GROUP="${USER}"
if [ "$(uname -s)" == "Darwin" ]; then
    GROUP="staff"
fi

sudo curl --silent --show-error -o ${DEST} -L https://github.com/rholder/debinate/releases/download/v0.7.0/debinate && \
    sudo chmod +x ${DEST} && \
    sudo mkdir -p /opt && \
    sudo chown "${USER}":"${GROUP}" /opt
