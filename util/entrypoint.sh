#!/bin/sh

TABLES_PATH=/opt/rainbowcrack/tables


find_rcrack () {
    test -x /usr/local/bin/rcrack && echo /usr/local/bin/rcrack
    find /opt/rainbowcrack -type f -name rcrack
}


RAINBOWCRACK_BIN="`find_rcrack|head -n1`"
test -x ${RAINBOWCRACK_BIN} || exit 1
cd $(dirname `readlink -f $RAINBOWCRACK_BIN`)

case "$1" in
    shell) exec /bin/bash;;
    help) exec ${RAINBOWCRACK_BIN} --help;;
    *) exec ${RAINBOWCRACK_BIN} ${TABLES_PATH}/*.rt "$@";;
esac
