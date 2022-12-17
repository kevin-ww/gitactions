#!/bin/bash

# the directory containing the script file

set -o errtrace

trap "echo ERROR: There was an error in ${FUNCNAME-main context}, details to follow" ERR
dir="$(
    cd "$(dirname "$0")" || exit
    pwd
)"

cd "$dir" || exit

usage() {
    echo 'usage: invoke this file with function name directly: example: ./make.sh local_build'
}

test0() {
    echo ' this is the script located in caller repo.'
    pats || true
}

test1() {
    pats || "FATAL: Failed to find command pats" && exit 100
}

test2() {
    cat -n not_exist_file || echo 'file not found ' && exit 99
}

testx() {
    cat -n not_exist_file || echo 'file not found ' && exit 99
}

# if `$1` is a function, execute it. Otherwise, print usage
# compgen -A 'function' list all declared functions
# https://stackoverflow.com/a/2627461
FUNC=$(compgen -A 'function' | grep "$1")
[[ -n $FUNC ]] && {
    eval "$1"
} || usage
exit 0
