#!/bin/bash
set -e

if [ "$1" = "--install" ]; then
    this_script="$( realpath "$0" )"
    cd "$( dirname "$0" )"
    mkdir -pv .git/hooks
    rm -fv .git/hooks/pre-commit
    ln -sv "$this_script" .git/hooks/pre-commit
    exit
fi

readarray -t staged_files < <(git diff --name-only --cached)
echo "***********************"
echo "* Linting staged files:" "${staged_files[@]}"
echo "***********************"

if ! npx eslint --no-warn-ignored -- "${staged_files[@]}"; then
    npx eslint --no-warn-ignored --fix -- "${staged_files[@]}"
    echo "Please check the changes from \"eslint --fix\" and try again." 
    exit 1
fi
