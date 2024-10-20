# Logging Library

declare -A _log_levels=([FATAL]=0 [ERROR]=1 [WARN]=2 [INFO]=3 [DEBUG]=4 [VERBOSE]=5)
declare -i _log_level=3
set_log_level() {
  level="${1:-INFO}"
  _log_level="${_log_levels[$level]}"
}

log_execute() {
  level=${1:-INFO}
  if (( $1 >= ${_log_levels[$level]} )); then
    "${@:2}" >/dev/null
  else
    "${@:2}"
  fi
}

LOG_NOFORMAT="\033[0m";
LOG_RED="\033[0;31m";
LOG_GREEN="\033[0;32m";
LOG_ORANGE="\033[0;33m";
LOG_BLUE="\033[0;34m";
LOG_PURPLE="\033[0;35m";
LOG_CYAN="\033[0;36m";
LOG_YELLOW="\033[1;33m";

LOG_FATAL=$LOG_RED
LOG_ERROR=$LOG_RED
LOG_WARN=$LOG_YELLOW
LOG_INFO=$LOG_BLUE
LOG_DEBUG=$LOG_PURPLE
LOG_VERBOSE=$LOG_CYAN
# logging_colors() {
#   if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
#     LOG_NOFORMAT='\033[0m' 
#     LOG_RED='\033[0;31m' 
#     LOG_GREEN='\033[0;32m' 
#     LOG_ORANGE='\033[0;33m' 
#     LOG_BLUE='\033[0;34m' 
#     LOG_PURPLE='\033[0;35m' 
#     LOG_CYAN='\033[0;36m' 
#     LOG_YELLOW='\033[1;33m'
#   else
#     LOG_NOFORMAT='' LOG_RED='' LOG_GREEN='' LOG_ORANGE='' LOG_BLUE='' LOG_PURPLE='' LOG_CYAN='' LOG_YELLOW=''
#   fi
# }

get_fatal()   { echo >&2 -en "${LOG_FATAL}FATAL ${LOG_NOFORMAT}";  }
get_error()   { echo >&2 -en "${LOG_ERROR}ERROR ${LOG_NOFORMAT}";  }
get_warning() { echo >&2 -en    "${LOG_WARN}WARN   ${LOG_NOFORMAT}";  }
get_info()    { echo >&2 -en    "${LOG_INFO}INFO   ${LOG_NOFORMAT}";  }
get_debug()   { echo >&2 -en   "${LOG_DEBUG}DEBUG ${LOG_NOFORMAT}";  }
get_verbose() { echo >&2 -en "${LOG_VERBOSE}VERBOSE${LOG_NOFORMAT}";  }

_log_color() {
  level=${1:-WARN}
  usedate=${2:-1}
  case $level in
    FATAL)   logstr=$(get_fatal) ;;
    ERROR)   logstr=$(get_error) ;;
    WARN)    logstr=$(get_warning) ;;
    INFO)    logstr=$(get_info) ;;
    DEBUG)   logstr=$(get_debug) ;;
    VERBOSE) logstr=$(get_verbose) ;;
  esac
  if (( $usedate )); then
    echo "$(date) $logstr"
  else
    echo "$logstr"
  fi

}
# add a timestamp to the log message
log() {
  level=${1:-INFO}
  (( _log_level >= ${_log_levels[$level]} )) && echo >&2 -e "$(_log_color $level 0): ($*)"
}

log_fatal()   { (( _log_level >= ${_log_levels[FATAL]} ))   && echo >&2 -e "$(date) ${LOG_FATAL}FATAL${LOG_NOFORMAT}: ($*)";  }
log_error()   { (( _log_level >= ${_log_levels[ERROR]} ))   && echo >&2 -e "$(date) ${LOG_ERROR}ERROR${LOG_NOFORMAT}: ($*)";  }
log_warning() { (( _log_level >= ${_log_levels[WARN]} ))    && echo >&2 -e "$(date) ${LOG_WARN}WARN${LOG_NOFORMAT}: ($*)";  }
log_info()    { (( _log_level >= ${_log_levels[INFO]} ))    && echo >&2 -e "$(date) ${LOG_INFO}INFO${LOG_NOFORMAT}: ($*)";  }
log_debug()   { (( _log_level >= ${_log_levels[DEBUG]} ))   && echo >&2 -e "$(date) ${LOG_DEBUG}DEBUG${LOG_NOFORMAT}: ($*)";  }
log_verbose() { (( _log_level >= ${_log_levels[VERBOSE]} )) && echo >&2 -e "$(date) ${LOG_VERBOSE}VERBOSE${LOG_NOFORMAT}: ($*)"; }

# functions for logging command output
log_debug_file()   { (( _log_level >= ${_log_levels[DEBUG]} ))   && [[ -f $1 ]] && echo "=== command output start ===" && cat "$1" && echo "=== command output end ==="; }
log_verbose_file() { (( _log_level >= ${_log_levels[VERBOSE]} )) && [[ -f $1 ]] && echo "=== command output start ===" && cat "$1" && echo "=== command output end ==="; }