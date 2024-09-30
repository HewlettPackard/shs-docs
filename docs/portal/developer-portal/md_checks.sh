#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Function to run the Spell check on a markdown file
run_spell_check() {
  local file_path=$1
  echo " "
  echo "----- SPELL CHECK on $file_path -----"
  docker run --rm -ti -v "$REPO_ROOT":/workdir arti.hpc.amslabs.hpecorp.net/third-party-docker-stable-local/tmaier/markdown-spellcheck:latest "**/$file_path" -r -n -a
}

# Function to run the Style check on a markdown file
run_style_check() {
  local file_path=$1
  echo " "
  echo "----- STYLE CHECK on $file_path -----"
  docker run -v "$REPO_ROOT":/workdir arti.hpc.amslabs.hpecorp.net/third-party-docker-stable-local/ghcr.io/igorshubovych/markdownlint-cli:v0.31.1 -c "/workdir/.github/config//markdown_style.yaml" "**/$file_path"
}

# Function to run the Link check on a markdown file
run_link_check() {
  local file_path=$1
  echo " "
  echo "----- LINK CHECK on $file_path -----"
  docker run --rm -ti -v "$REPO_ROOT":/workdir --workdir /workdir arti.hpc.amslabs.hpecorp.net/third-party-docker-stable-local/ghcr.io/tcort/markdown-link-check:3.9.3  --config "/workdir/.github/config/markdown_link.json" "docs/portal/developer-portal/$file_path"
}


# Ensure at least one path is supplied as an argument
if [ $# -eq 0 ]; then
  echo "Usage: $0 /path/to/file_or_directory [...additional paths]"
  exit 1
fi

# Process each argument
for PATH_TO_CHECK in "$@"; do
  if [ -f "$PATH_TO_CHECK" ]; then
    # It's a file, run checks on it
    run_spell_check "$PATH_TO_CHECK"
    run_style_check "$PATH_TO_CHECK"
    run_link_check "$PATH_TO_CHECK"
  elif [ -d "$PATH_TO_CHECK" ]; then
    # It's a directory, find all .md files
    MD_FILES=$(find "$PATH_TO_CHECK" -type f -name "*.md")

    # Run Spell check on all files
    for md_file in $MD_FILES; do
      run_spell_check "$md_file"
    done

    # Run Style check on all files
    for md_file in $MD_FILES; do
      run_style_check "$md_file"
    done

    # Run Link check on all files
    for md_file in $MD_FILES; do
      run_link_check "$md_file"
    done
  else
    echo "Error: $PATH_TO_CHECK is not a valid file or directory"
  fi
done
