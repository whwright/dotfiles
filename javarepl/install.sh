#!/bin/bash
# install javarepl jar

set -o errexit
set -o nounset
set -o pipefail
. functions.sh

DOWNLOAD_LINK="http://albertlatacz.published.s3.amazonaws.com/javarepl/javarepl.jar"
INSTALL_LOC="/opt/javarepl.jar"

if [ ! -f ${INSTALL_LOC} ]; then
    sudo curl --silent --show-error "${DOWNLOAD_LINK}" -o ${INSTALL_LOC}
else
    info "javarepl already installed"
fi
