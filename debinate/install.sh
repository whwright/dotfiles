#!/usr/bin/env bash

set -o errexit
source lib.sh

DEST=/usr/local/bin/debinate

if [ -f ${DEST} ]; then
    info "debinate already installed"
    exit 0
fi

sudo curl -o ${DEST} -L https://github.com/rholder/debinate/releases/download/v0.7.0/debinate && \
sudo chmod +x ${DEST} && \
sudo chown ${USER}:${USER} /opt

