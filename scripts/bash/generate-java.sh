#!/usr/bin/env bash

# set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

source $script_dir/logging_lib.sh

# log_debug "This is a debug statement"
# log_error "This is an error"
# log_warning "This is a warning"
# log_fatal "This is a fatal error"
# log_verbose "This is a verbose log!"

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-n] [-d] -i <FILE> command

Generate OpenAPI Client Code

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-n, --dry       Run generator in dry run mode
-d, --debug     Set debug output logging
-i, --input     Open API Input File

Commands:

  generate     generate client code

EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  dryrun=0

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    -d | --debug) set_log_level DEBUG ;;
    --no-color) NO_COLOR=1 ;;
    -n | --dry) dryrun=1 ;; # example flag
    -i | --input) # example named parameter
      input_file="${2-}"
      log_debug "parsing input_file=$input_file"
      shift
      ;;
    -g | --generator)
      generator="${2-}"
      log_debug "parsing generator=$generator"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  command=("$@")

  # check required params and arguments
  [[ -z "${input_file-}" ]] && die "Missing required parameter: input_file"
  # [[ ${#commands[@]} -eq 0 ]] && die "Missing script command"

  return 0
}


setup_opt_args(){
  
  opts=""
  [[ $dryrun == 1 ]] && {
    opts="$opts --dry-run"
  }
  
  args=""

  case "$command" in
    # Parse options to the install sub command
    generate)
      args="$args $command -g $generator -c $gconfig_file -i $input_file -o $outdir"
      opts="$opts --skip-validate-spec"
      ;;
    config-help)
      args="$args $command -g $generator"
      ;;
    validate)
      args="$args $command -i $input_file"
      ;;
    *) 
      args="$args $command" 
      ;;
  esac

}

OPENAPI_JAR="bin/openapi-generator-cli.jar"
OPENAPI_EXEC="java -jar $OPENAPI_JAR"


set_log_level INFO
# log_execute INFO date

# Defaults
input_file="config/twc_openapi_oa3_update.json"

# Generator Configuration File
default_generator="java"
default_gconfig_file="config/${default_generator}_config.json"
default_outdir="twc_api_oa3_java"

generator=$default_generator
gconfig_file=$default_gconfig_file
outdir=$default_outdir

parse_params "$@"

setup_opt_args

log_debug "dryrun      - ${dryrun}"
log_debug "input_file  - ${input_file}"
log_debug "command     - ${command}"

case "$command" in
  # Parse options to the install sub command
  generate)
    log_debug "generator   - ${generator}"
    log_debug "config_file - ${gconfig_file}"
    log_debug "outdir      - ${outdir}"
    ;;
  config-help)
    ;;
  validate)
    ;;
esac

log_debug "$OPENAPI_EXEC $args $opts"

$OPENAPI_EXEC $args $opts --global-property=debugModels &> logs/${command}_log.txt
