#!/bin/bash

function log() {
    echo 1>&2 "$1"
}

# Check swift
if ! type swift > /dev/null; then
    log "❌ Error: swift not installed"
    exit 0
fi


# Paths
current_dir=$(dirname $0)
root_dir=$(cd $current_dir/../../.. && pwd)
infra_package="$root_dir/tools/swift/swift-infra-package"
bin_path="$infra_package/.build/release/swiftlint"

cmd="$bin_path lint --quiet --config $root_dir/.swiftlint.yml"


# Check bin
if ! [ -f $bin_path ]; then
    $current_dir/setup_linter.sh
fi


# Run
log "🚀 Running SwiftLint $@..."
SDKROOT=(xcrun --sdk macosx --show-sdk-path)
$cmd $@

log "🚀 SwiftLint complete!"
