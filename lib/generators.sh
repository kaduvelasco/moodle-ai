#!/usr/bin/env bash

generate_ai_context() {

    local MOODLE_PATH="$1"
    local MOODLE_VERSION="$2"

    OUTPUT="$MOODLE_PATH/AI_CONTEXT.md"

    cat <<EOF > "$OUTPUT"
# Moodle AI Context

Version: $MOODLE_VERSION

Root structure:

mod/
local/
blocks/
admin/

This project is a Moodle installation.
EOF

}
