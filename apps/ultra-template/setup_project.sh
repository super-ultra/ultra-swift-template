#!/bin/bash

# Check tuist
if ! type tuist > /dev/null; then
    echo "❌ Error: tuist not installed: https://github.com/tuist/tuist"
    exit 0
fi

# Paths
current_dir=$(dirname $0)

# Run
tuist install --path "$current_dir"
tuist generate --no-open --path "$current_dir"

