#!/bin/bash

source logging_lib.sh
# logging_colors

set_log_level INFO

# log_info  "Starting the script..."

# # method 1 of controlling a command's output based on log level
# log_execute INFO date

# # method 2 of controlling the output based on log level
# date &> date.out
# log_debug_file date.out

# log_debug "This is a debug statement"
# log_error "This is an error"
# log_warning "This is a warning"
# log_fatal "This is a fatal error"
# log_verbose "This is a verbose log!"

# test log function
log INFO "This is an info message"
log DEBUG "This is a debug message"
log VERBOSE "This is a verbose message"