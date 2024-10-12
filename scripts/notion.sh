#!/bin/bash

# This script is used to download files from Notion.so using the official Notion API.

# Example curl command to get a list of blocks in a page
# curl 'https://api.notion.com/v1/blocks/13d6da822f9343fa8ec14c89b8184d5a/children?page_size=100' \
#   -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
#   -H "Notion-Version: 2022-06-28"

# Response JSON
# {
#     "object": "list",
#     "results": [
#         {
#             "object": "block",
#             "id": "47a920e4-346c-4df8-ae78-905ce10adcb8",
#             "parent": {
#                 "type": "page_id",
#                 "page_id": "13d6da82-2f93-43fa-8ec1-4c89b8184d5a"
#             },
#             "created_time": "2022-12-15T00:18:00.000Z",
#             "last_edited_time": "2022-12-15T00:18:00.000Z",
#             "created_by": {
#                 "object": "user",
#                 "id": "c2f20311-9e54-4d11-8c79-7398424ae41e"
#             },
#             "last_edited_by": {
#                 "object": "user",
#                 "id": "c2f20311-9e54-4d11-8c79-7398424ae41e"
#             },
#             "has_children": false,
#           	"archived": false,
#             "in_trash": false,
#             "type": "paragraph",
#             "paragraph": {
#                 "rich_text": [],
#                 "color": "default"
#             }
#         },
#         {
#             "object": "block",
#             "id": "3c29dedf-00a5-4915-b137-120c61f5e5d8",
#             "parent": {
#                 "type": "page_id",
#                 "page_id": "13d6da82-2f93-43fa-8ec1-4c89b8184d5a"
#             },
#             "created_time": "2022-12-15T00:18:00.000Z",
#             "last_edited_time": "2022-12-15T00:18:00.000Z",
#             "created_by": {
#                 "object": "user",
#                 "id": "c2f20311-9e54-4d11-8c79-7398424ae41e"
#             },
#             "last_edited_by": {
#                 "object": "user",
#                 "id": "c2f20311-9e54-4d11-8c79-7398424ae41e"
#             },
#             "has_children": false,
#           	"archived": false,
#             "in_trash": false,
#             "type": "file",
#             "file": {
#                 "caption": [],
#                 "type": "file",
#                 "file": {
#                     "url": "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/fa6c03f0-e608-45d0-9327-4cd7a5e56e71/TestFile.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20221215%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20221215T002012Z&X-Amz-Expires=3600&X-Amz-Signature=bf13ca59f618077852298cb92aedc4dd1becdc961c31d73cbc030ef93f2853c4&X-Amz-SignedHeaders=host&x-id=GetObject",
#                     "expiry_time": "2022-12-15T01:20:12.928Z"
#                 }
#             }
#         },
#     ],
#     "next_cursor": null,
#     "has_more": false,
#     "type": "block",
#     "block": {}
# }

# we want blocks of type "file" and download the file from the URL

# we will create a function that takes a block id or a page id and downloads all the files in that page

function download_files() {
  local page_id=$1
  # 'https://api.notion.com/v1/blocks/'"$page_id"'/children?page_size=100'
  local url="https://api.notion.com/v1/blocks/$page_id/children?page_size=100"
  echo $url
  local blocks=$(curl $url \
    -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
    -H "Notion-Version: 2022-06-28")
  echo $blocks
  urls=$(echo $blocks | jq -r '.results[] | select(.type == "file") | .file.file.url')
  for url in $urls; do
    echo $url
  done
}

# Example: 
# * Input: https://www.notion.so/cosgroma/dbs-36166cf3565d49af87a4df42a4615a34?pvs=4
# * Answer: 36166cf3565d49af87a4df42a4615a34
function parse_id_from_url() {
  local url=$1
  local id=$(echo $url | sed -n 's/.*\/\([^\/]*\)\?pvs.*/\1/p')
  id=$(cut -d'-' -f2- <<< $id)
  echo $id
}

function is_url() {
  local url=$1
  if [[ $url =~ ^https?:// ]]; then
    echo "true"
  else
    echo "false"
  fi
}

function notion() {
  local url=$1
  local id=$(parse_id_from_url $url)
  if [[ $(is_url $url) == "true" ]]; then
    download_files $id
  else
    download_files $url
  fi
}
