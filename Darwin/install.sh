#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

# check in homebrew in installed first
if ! type brew > /dev/null ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# TODO: should this be a brew file?
brew install coreutils \
             tmux
