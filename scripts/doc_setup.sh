#!/bin/bash

usage_docs=(
    "usage/quickstart.md"
    "usage/tutorial.md"
    "usage/user-guide.md"
    "usage/advanced.md"
    "usage/faq.md"
)

developer_docs=(
    "developer/dev-plan.md"
    "developer/requirements.md"
    "developer/design.md"
    "developer/src.md"
    "developer/tests.md"
    "developer/troubleshooting.md"
    "developer/security.md"
)

integrators_docs=(
    "integrators/interface.md"
    "integrators/api.md"
    "integrators/exceptions.md"
    "integrators/environment_variables.md"
)

community_docs=(
    "community/contributing.md"
    "community/code-of-conduct.md"
    "community/license.md"
    "community/support.md"
    "community/roadmap.md"
    "community/changelog.md"
    "community/versioning.md"
    "community/acknowledgements.md"
    "community/authors.md"
)

docs_collection=(
    "${usage_docs[@]}"
    "${developer_docs[@]}"
    "${integrators_docs[@]}"
    "${community_docs[@]}"
)

DOC_DIR="docs"
DOC_FILE="index.md"

# Create the docs directory if it doesn't exist
if [ ! -d "$DOC_DIR" ]; then
    mkdir $DOC_DIR
fi

# Create the index.md file if it doesn't exist
if [ ! -f "$DOC_DIR/$DOC_FILE" ]; then
    touch $DOC_DIR/$DOC_FILE
fi

# Add the new docs to the index.md file
for doc in "${docs_collection[@]}"
do
    # echo "Adding $doc to $DOC_FILE"
    # echo "[$doc]($doc)" >> $DOC_DIR/$DOC_FILE
    parent_dir=$(dirname $doc)
    if [ ! -d "$DOC_DIR/$parent_dir" ]; then
        mkdir -p $DOC_DIR/$parent_dir
    fi
    touch $DOC_DIR/$doc
done