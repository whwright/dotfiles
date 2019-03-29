#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

fail "this should not run yet"
exit 1
