#!/usr/bin/env bash

if [[ $# < 3 ]]; then
    echo "usage: $0 <target> <release_name> <paths...>" 1>&2
    exit 1
fi

TARGET=$1
RELEASE_NAME=$2

shift 2
PATHS=$@

if [[ "$TARGET" == "windows" ]]; then
    # From https://zaiste.net/posts/how-to-join-elements-of-array-bash/
    function join { local IFS="$1"; shift; echo "$*"; }
    
    set -xe

    PATHS=$(join ',' ${PATHS[@]})
    echo "Compress-Archive -Path $PATHS -DestinationPath \"$HOME/$RELEASE_NAME.zip\"" | powershell
else
    set -xe
    zip -r $HOME/$RELEASE_NAME.zip $PATHS
fi
