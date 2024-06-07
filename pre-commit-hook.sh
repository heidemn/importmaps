#!/bin/bash
set -e

if [ "$1" = "--install" ]; then
    this_script="$( realpath "$0" )"
    cd "$( dirname "$0" )"
    mkdir -pv .git/hooks
    mv .git/hooks/pre-commit .git/hooks/pre-commit.OLD || true
    ln -sv "$this_script" .git/hooks/pre-commit
    exit
fi

readarray -t staged_files < <(git diff --name-only --cached)
echo "Staged files:" "${staged_files[@]}"

set -x
if ! npx eslint --no-warn-ignored -- "${staged_files[@]}"; then
    npx eslint --no-warn-ignored --fix -- "${staged_files[@]}"
    exit 1
fi
