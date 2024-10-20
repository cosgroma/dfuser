#!/bin/bash

chatgpt_dir="chatgpt_sessions"

for f in `ls $chatgpt_dir/*.html`; do
    new_file=${f%.*}
    pandoc --from html --to markdown_strict -o $new_file.md $f;
    # pandoc --from html --to json -o $new_file.json $f;
done;