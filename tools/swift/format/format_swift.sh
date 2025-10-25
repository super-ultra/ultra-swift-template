#!/bin/bash

# Check swift
if ! type swift > /dev/null; then
    echo "❌ Error: swift not installed"
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
echo "🚀 Running SwiftFormat $@..."
SDKROOT=(xcrun --sdk macosx --show-sdk-path)
$cmd $@

echo "🚀 SwiftFormat complete!"
