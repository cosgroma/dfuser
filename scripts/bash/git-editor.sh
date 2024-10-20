#!/bin/bash
sublpath=`cygpath "C:\Program Files\Sublime Text 3\subl.exe"`
"$sublpath" -wn `cygpath -w $1`