#!/bin/bash
[[ $_arch == "x86" ]] || return 1
export PATH="$HOME/.rvm/bin:$PATH"