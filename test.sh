#!/bin/sh

# NOTE: run this script

case $1 in
  test)
    docker build -t rainbowcrack:test .
    docker run \
      -v `pwd`/test/:/tmp/hash \
      -v ${2:-/tmp/rainbowtables}:/opt/rainbowcrack/tables \
      -it rainbowcrack:test \
      -f /tmp/hash/lmhashtest.pwdump
  ;;

  *)
    echo "Please run this script as:" >&2
    echo "sh $0 test /path/to/rainbowtables/" >&2
  ;;
esac
