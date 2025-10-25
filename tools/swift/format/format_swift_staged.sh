#!/bin/bash

staged_swift_files=$(git diff --diff-filter=d --name-only --staged | grep ".swift")

if [ -z "$staged_swift_files" ]; then
    # Nothing to format..
    exit 0
fi

# Paths
current_dir=$(dirname $0)
root_dir=$(cd $current_dir/../../.. && pwd)
infra_package="$root_dir/tools/swift/swift-infra-package"
release_dir="$infra_package/.build/release"
bin_path="$infra_package/.build/release/swiftformat"

cmd="$bin_path"


# Check bin
if ! [ -f $bin_path ]; then
    $current_dir/setup_formatter.sh
fi

# Run
$current_dir/git_format_staged.py --formatter "${cmd} --quiet stdin --stdinpath '{}'" "*.swift"

# Check
if [ $? -ne 0 ]
then
    echo "❌ Format failed. Commit aborted."
    exit 1
fi

any_staged_files=$(git diff --name-only --staged)
if [ -z "$any_staged_files" ]
then
    echo "❌ Commit aborted. Nothing to commit after formatting."
    exit 1
fi
