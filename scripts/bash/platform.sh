#!/bin/bash

# case $(uname) in
#   Linux)
#     echo "linux"
#     ;;
#   Darwin)
#     echo "darwin"
#     ;;
#   *)
#     echo "windows"
#     ;;
# esac


case $(uname) in
  Linux | Darwin)
    echo "linux or Darwin"
    ;;
  *)
    echo "windows"
    ;;
esac
