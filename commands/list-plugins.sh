#!/usr/bin/env bash

source "$(dirname "$0")/../lib/config.sh"

echo "=== Moodle Plugin List ==="
echo ""

load_config

if [ -z "$MOODLE_PATH" ]; then
    echo "Configuration not found. Run:"
    echo "moodle-ai init"
    exit 1
fi

INDEX_FILE="$MOODLE_PATH/MOODLE_PLUGIN_INDEX.md"

if [ ! -f "$INDEX_FILE" ]; then
    echo "Plugin index not found. Run:"
    echo "moodle-ai update"
    exit 1
fi

cat "$INDEX_FILE"