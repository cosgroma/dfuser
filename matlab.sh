#!/bin/bash
################################################################################
## @file    matlab.sh - {{project_name}}
## @author  Mathew Cosgrove mathew.cosgrove@ngc.com
## @Date:   2021-01-07 03:26:10
## @brief
## @copyright
## @version
## @Last Modified by:   cosgrma
## @Last Modified time: 2021-07-16 00:12:13
#
## @details
## @par URL
##  @n
#
## @par Purpose
#
##
## @note
##
#
## @par Usage
##
################################################################################
[[ $_arch == "x86" ]] || return 1
function set_matlab_version() {
  case $_myos in
     Linux) MATLAB_PATH=/opt/MATLAB ;;
  esac
  [[ -e $MATLAB_PATH ]] || (echo "ERROR: matlab not installed "; return)
  printf -v str '%s ' `ls $MATLAB_PATH`;
  IFS=' ' declare -a 'versions=($str)';
  vlen=${#versions[@]};
  while true; do
    echo -e "Select Version ($GREEN[*]$RESET current, q to quit):"
    for (( i=0; i<${vlen}; i++ )); do
      [[ -n $matlab_version && $matlab_version == ${versions[$i]} ]] && attr="[*] " || attr="    "
      echo -e $i ': '${versions[$i]}$GREEN$attr$RESET
    done
    read version
    [[ $version == "q" ]] && return;
    [[ $version -lt $vlen && $version -ge 0 ]] && break;
    echo -e $RED"ERROR"$RESET": bad selection $YELLOW$version$RESET"
  done
  matlab_version=${versions[$version]}
  echo -e "set version to: $GREEN$matlab_version$RESET"
}


function matlab() {
  [[ -z $matlab_version ]] && set_matlab_version
  $MATLAB_PATH/$matlab_version/bin/matlab
}
export no_proxy=localhost,$no_proxy
