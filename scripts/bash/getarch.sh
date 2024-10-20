#!/bin/bash
case $(uname -m) in
  arm*) _arch=arm ;;    # matches anything starting with "a"
  x86*) _arch=x86 ;;    # matches anything starting with "a"
  * ) _arch=fucked && echo "WARN: arch unknown";; # catchall, matches anything not matched above
esac
