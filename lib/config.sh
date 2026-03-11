#!/usr/bin/env bash

CONFIG_FILE=".moodle-ai"

load_config() {

    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    fi

}

save_config() {

    local MOODLE_PATH="$1"
    local MOODLE_VERSION="$2"

    if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" <<EOF
MOODLE_PATH=$MOODLE_PATH
MOODLE_VERSION=$MOODLE_VERSION
EOF

}