#!/usr/bin/env bash

source "$(dirname "$0")/../lib/config.sh"

QUERY="$1"

if [ -z "$QUERY" ]; then
    echo "Usage:"
    echo "moodle-ai search <text>"
    exit 1
fi

load_config

INDEX_FILE="$MOODLE_PATH/MOODLE_PLUGIN_INDEX.md"

if [ ! -f "$INDEX_FILE" ]; then
    echo "Plugin index not found. Run:"
    echo "moodle-ai update"
    exit 1
fi

echo "=== Search results for: $QUERY ==="
echo ""

grep -i "$QUERY" "$INDEX_FILE"