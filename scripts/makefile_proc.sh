59896  makefile_list=$(find . -name "Makefile" | grep -v 'comp' | grep -v 'build' | grep -v 'core' | grep -v 'runtime')
59897  for f in ${makefile_list[@]}; do echo $f; done;
59904  for f in ${makefile_list[@]}; do echo $f; make-list -f $f;  done; >> make-targets.txt
59906  (for f in ${makefile_list[@]}; do echo $f; make-list -f $f;  done;) > make-targets.txt
59908  (for f in ${makefile_list[@]}; do echo ## $f; echo ""; make-list -f $f; echo ""; done;) > make-targets.txt
59909  (for f in ${makefile_list[@]}; do echo "\#\#" $f; echo ""; make-list -f $f; echo ""; done;) > make-targets.txt
59911  (for f in ${makefile_list[@]}; do echo "##" $f; echo ""; make-list -f $f; echo ""; done;) > make-targets.txt
59913  makefile_list=$(find . -name "*.mk" | grep -v 'comp' | grep -v 'build' | grep -v 'core' | grep -v 'runtime')
59914  (for f in ${makefile_list[@]}; do echo "##" $f; echo ""; make-list -f $f; echo ""; done;) > make-sub-targets.txt
59924  makefile_list=$(find . -name "Makefile" | grep -v 'comp' | grep -v 'build' | grep -v 'core' | grep -v 'runtime')
59925  for f in ${makefile_list[@]}; do echo "##" $f; echo ""; grep ":=" $f; echo ""; done;
59926  makefile_list=$(find . -name "Makefile" -o -name "*.mk" | grep -v 'comp' | grep -v 'build' | grep -v 'core' | grep -v 'runtime')
59927  for f in ${makefile_list[@]}; do echo "##" $f; echo ""; grep ":=" $f; echo ""; done;
59928  for f in ${makefile_list[@]}; do echo "##" $f; echo ""; grep "(:=)" $f; echo ""; done;
59929  for f in ${makefile_list[@]}; do echo "##" $f; echo ""; grep "(^export|:=)" $f; echo ""; done;
59930  for f in ${makefile_list[@]}; do echo "##" $f; echo ""; grep "(^export)" $f; echo ""; done;
59931  (for f in ${makefile_list[@]}; do echo "##" $f; echo ""; grep "(^export)" $f; echo ""; done;) > export_config-mk.md
59934  (for f in ${makefile_list[@]}; do echo "##" $f; echo ""; grep ":=" $f; grep -v "^export"; echo ""; done;) > config_var-mk.md
59935  (for f in ${makefile_list[@]}; do echo "##" $f; echo ""; grep ":=" $f; grep -v "^export"; echo ""; done;) > config_var-mk.md
59936  (for f in ${makefile_list[@]}; do echo "##" $f; echo ""; grep ":=" $f | grep -v "^export"; echo ""; done;) > config_var-mk.md
59938  history | grep makefile_list
59939  history | grep makefile_list > scripts/makefile_proc.sh
