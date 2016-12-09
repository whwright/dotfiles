#!/bin/bash

. functions.sh

# is this a bad idea?
DOWNLOAD_LINK="http://albertlatacz.published.s3.amazonaws.com/javarepl/javarepl.jar"
INSTALL_LOC="/opt/javarepl.jar"

if [ ! -f ${INSTALL_LOC} ]; then
    sudo curl --silent --show-error -o ${INSTALL_LOC} "${DOWNLOAD_LINK}"
else
    info "javarepl already installed"
fi
