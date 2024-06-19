#!/bin/bash

function _northrop_proxy() {
  export http_proxy=http://$nuser:$(echo -n $userpass64 | base64 -d | sed 's/;/%3B/g' )@westproxy.northgrum.com:80/
  export https_proxy=http://$nuser:$(echo -n $userpass64 | base64 -d | sed 's/;/%3B/g' )@westproxy.northgrum.com:80/
  export no_proxy=.northgrum.com,.ngc
}

case $(uname -n) in
  *.northgrum.com )
    _northrop_proxy
    ;;
  * )
    return 1;
    ;;
esac