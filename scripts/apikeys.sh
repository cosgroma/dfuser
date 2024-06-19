API_KEYS_DIR=$HOME/.dfuser/apikeys

function apikey() {
  if [ -z "$1" ]; then
    echo "Usage: apikey <keyname>"
    return 1
  fi
  keyname=$(echo $1 | tr '[:lower:]' '[:upper:]')
  keyname=${keyname}_API_KEY
  if [ -z "${!keyname}" ]; then
    echo "API key not found: $keyname"
    return 1
  fi
  echo ${!keyname}
}

function load_api_keys() {
  # Iterate over all files in the directory
  for file in $API_KEYS_DIR/*; do
    # Get the filename
    filename=$(basename $file)
    # Get the key name
    keyname=$(echo $filename | cut -d'.' -f1 | tr '[:lower:]' '[:upper:]')
    keyname=${keyname}_API_KEY
    echo "$filename -> $keyname"
    # Get the key value
    keyvalue=$(cat $file)
    # Export the key
    export $keyname=$keyvalue
done
}
# export JIRA_API_KEY=$(cat $HOME/.dfuser/apikeys/jira.apikey)
# export OPENAI_API_KEY=$(cat $HOME/.dfuser/apikeys/openai.apikey)
# export NOTION_API_KEY=$(cat $HOME/.dfuser/apikeys/notion.apikey)
# export GITHUB_API_KEY=$(cat $HOME/.dfuser/apikeys/github.apikey)
