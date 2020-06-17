#!/usr/bin/env bash

source lib.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# check in homebrew in installed first
if ! type brew > /dev/null ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew bundle install --file="${DIR}/Brewfile"
