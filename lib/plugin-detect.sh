#!/usr/bin/env bash

detect_plugin() {

    local PLUGIN_FULL_PATH="$1"

    if [ ! -d "$PLUGIN_FULL_PATH" ]; then
        echo "Plugin não encontrado: $PLUGIN_FULL_PATH"
        exit 1
    fi

    PLUGIN_NAME=$(basename "$PLUGIN_FULL_PATH")
    PLUGIN_TYPE=$(basename "$(dirname "$PLUGIN_FULL_PATH)")
    COMPONENT="${PLUGIN_TYPE}_${PLUGIN_NAME}"

    export PLUGIN_NAME
    export PLUGIN_TYPE
    export COMPONENT

}