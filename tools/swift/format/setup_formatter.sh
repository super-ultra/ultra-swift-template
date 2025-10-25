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

build_cmd="swift build -c release --cache-path $infra_package/.cache --package-path $infra_package --product swiftformat"

# Run
echo "📦 Building SwiftFormat..."
SDKROOT=(xcrun --sdk macosx --show-sdk-path)
$build_cmd

echo "📦 Building SwiftFormat complete!"
echo ""
