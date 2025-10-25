#!/bin/bash
set -e

# Add arc directory to PATH for Xcode Script build step
export PATH="${PATH}:/opt/homebrew/bin"

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
root_dir=$(cd "$script_dir/../../.."; pwd)
lint_cmd="$root_dir/tools/swift/lint/lint_swift.sh"

function log() {
    echo 1>&2 "$1"
}

function lint_files() {
    local file_number=0
    local files=("$@")
    for file_path in "${files[@]}"
    do
        export SCRIPT_INPUT_FILE_$file_number=$file_path
        file_number=$((file_number + 1))
    done
    export SCRIPT_INPUT_FILE_COUNT=$file_number
    "$lint_cmd" \
        --use-alternative-excluding \
        --force-exclude \
        ${LINT_STRICT:+"--strict"} \
        ${LINT_LENIENT:+"--lenient"} \
        --use-script-input-files
}


# Changed swift files comparing to master branch with relative path
base_path=""
files=""

set +e
base_path="$(git rev-parse --show-toplevel)"
master=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
merge_base=$(git merge-base --fork-point $master)
files=$(git diff $merge_base --diff-filter=d --name-only | grep ".swift$")
set -e

OIFS="$IFS"
IFS=$'\n'

declare -a result_files=()
for file_path in $files; do
    result_files+=("$base_path/$(echo $file_path | xargs)")
done


# Lint
if [ -n "$result_files" ]; then
    lint_files "${result_files[@]}"
else
    log "🚀 Nothing to lint"
fi
