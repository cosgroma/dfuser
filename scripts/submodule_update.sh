
list_submodule_urls() {
  git config --file .gitmodules --get-regexp url | awk '{ print $2 }'
}

GITHUB_ENTERPRISE_URL="https://github.northgrum.com"
GITHUB_URL="https://github.com"
GITHUB_ENTERPRISE_USER="cosgrma"
GITHUB_USER="cosgroma"

get_submodule_name_from_url() {
  echo $1 | awk -F/ '{ print $NF }' | awk -F. '{ print $1 }'
}

submodule_urls=$(list_submodule_urls)
for submodule_url in $submodule_urls; do
  if [[ $submodule_url == $GITHUB_URL* ]]; then
    new_submodule_url=${submodule_url/$GITHUB_URL/$GITHUB_ENTERPRISE_URL}
    new_submodule_url=${new_submodule_url/$GITHUB_USER/$GITHUB_ENTERPRISE_USER}
    submodule_name=$(get_submodule_name_from_url $submodule_url)
    printf "Changing $submodule_name url \nFrom:\t $submodule_url\nTo:\t $new_submodule_url\n"
    git config --file .gitmodules --replace-all submodule.$submodule_name.url $new_submodule_url
  fi
done