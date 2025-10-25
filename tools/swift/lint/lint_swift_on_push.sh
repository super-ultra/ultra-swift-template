#!/bin/bash

# Paths
current_dir=$(dirname $0)
root_dir=$(cd $current_dir/../../.. && pwd)
cmd="$current_dir/lint_swift_master_diff.sh"

# Run
result=$($cmd)

# Check
if [[ ! -z "$result" ]]
then
    while read -r line
    do 
        FILENAME=$(echo $line | cut -d':' -f 1 | rev | cut -d'/' -f 1 | rev)       
        L=$(echo $line | cut -d':' -f 2)
        C=$(echo $line | cut -d':' -f 3)
        TYPE=$(echo $line | cut -d':' -f 4 | cut -c 2-)
        RULE_DESCRIPTION=$(echo $line | cut -d':' -f 5 | cut -c 2-)
        RULE_NAME=$(echo $line | cut -d':' -f 6 | cut -d'(' -f 2 | rev | cut -c 2- | rev)
        
        if [ "$TYPE" = "error" ]
        then
            ICON=❌ #error
        else
            ICON=⚠️ #warning
        fi
        
        printf "$ICON $TYPE: $FILENAME:$L:$C - $RULE_DESCRIPTION ($RULE_NAME)\n" >&2

    done <<< "$result"

    exit 1
fi
