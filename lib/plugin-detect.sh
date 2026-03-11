#!/usr/bin/env bash

detect_plugin() {

    local PLUGIN_FULL_PATH="$1"

    PLUGIN_NAME=$(basename "$PLUGIN_FULL_PATH")
    PLUGIN_TYPE=$(basename "$(dirname "$PLUGIN_FULL_PATH")")

    COMPONENT="${PLUGIN_TYPE}_${PLUGIN_NAME}"

}
