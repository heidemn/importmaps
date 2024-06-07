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

set -x
npx eslint --no-warn-ignored -- $( git diff --name-only --cached )
