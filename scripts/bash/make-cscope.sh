#!/bin/bash

if [[ $# == 0 ]]; then
    PDIR=`pwd`
else
    PDIR=$1
fi;

! [ -d "$PDIR" ] && echo "PDIR is not a directory" && exit
csf=$PDIR/cscope.files
t_csf=$PDIR/temp.cscope.files
[ -e "$csf" ] && echo "cleaning previous scope files" && rm $csf

function find_source() {
  find $PDIR -name "*.[chxsS]" -print > $t_csf
}

function windows_filter() {
  while read line; do
    echo $(cygpath -aw $line) >> $csf;
  done < $t_csf
}

echo "making cscope for $PDIR, please wait..."

find_source

case $(uname) in
  Linux | Darwin)
    cat $t_csf > $csf
    ;;
  *)
    windows_filter
    ;;
esac

echo "finished processing source files... running cscope"

pushd . > /dev/null
cd $PDIR
cscope -b
popd > /dev/null

rm $t_csf
