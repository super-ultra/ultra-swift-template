#!/bin/bash

# Paths
current_dir=$(dirname $0)
root_dir=$(cd $current_dir/.. && pwd)

# Setup swift env
$current_dir/swift/lint/setup_linter.sh
$current_dir/swift/format/setup_formatter.sh

# Setup git hooks
echo "⚙️  git hooks (core.hooksPath) updated!"
git config core.hooksPath $root_dir/.githooks
