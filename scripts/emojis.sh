
# Declare an associative array
declare -A emojis

# Add more emojis
function add_emojis_json() {
  local json_file="$1"
  while IFS="=" read -r key value
  do
    emojis[$key]=$value
  done < <(jq -r "to_entries|map(\"\(.key)=\(.value)\")|.[]" $json_file)
}

test_add_emojis_json() {
  add_emojis_json "emojis.json"
  for key in "${!emojis[@]}"
  do
    echo "$key: ${emojis[$key]}"
  done
}


# Function to use emojis
function print_emoji() {
  local name="$1"
  echo "${emojis[$name]}"
}

function print_all_emojis() {
  for key in "${!emojis[@]}"
  do
    echo "$key: ${emojis[$key]}"
  done
}

# Export function and use it in other scripts
export -f print_emoji