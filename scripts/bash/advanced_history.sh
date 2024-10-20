# Function to append command status to history
append_status_to_history_v1() {
    local last_status=$?
    history 1 | sed 's/$/ - Success: '$last_status'/' >> ~/.bash_history_with_status
}
# Function to append command status, working directory, and time as a JSON string to history
append_status_to_history() {
    local last_status=$?
    local cwd=$(pwd)
    local cmd=$(history 1 | sed 's/^[ ]*[0-9]*[ ]*//') # Extracts the last command
    local timestamp=$(date --iso-8601=seconds) # Gets the current timestamp in ISO 8601 format

    # Create a JSON object
    local json_obj=$(printf '{"command": "%s", "status": %s, "directory": "%s", "timestamp": "%s"}\n' \
        "$(echo $cmd | sed 's/"/\\"/g')" "$last_status" "$(echo $cwd | sed 's/"/\\"/g')" "$timestamp")

    # Append the JSON object to the file
    echo $json_obj >> ~/.bash_history_with_json
}
# Set PROMPT_COMMAND
PROMPT_COMMAND="append_status_to_history; $PROMPT_COMMAND"

#export HISTTIMEFORMAT="%d/%m/%y %T "
