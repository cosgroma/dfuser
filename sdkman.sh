#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ $_arch == "x86" ]] || return 1
export SDKMAN_DIR="/home/cosgrma/.sdkman"
[[ -s "/home/cosgrma/.sdkman/bin/sdkman-init.sh" ]] && source "/home/cosgrma/.sdkman/bin/sdkman-init.sh"
