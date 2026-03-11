#!/usr/bin/env bash

check_moodle_install() {

    local PATH_MOODLE="$1"

    if [ -z "$PATH_MOODLE" ]; then
        echo "Caminho do Moodle não informado"
        exit 1
    fi

    if [ ! -d "$PATH_MOODLE" ]; then
        echo "Diretório não encontrado: $PATH_MOODLE"
        exit 1
    fi

    if [ ! -f "$PATH_MOODLE/version.php" ]; then
        echo "version.php não encontrado em $PATH_MOODLE"
        exit 1
    fi

    if [ ! -d "$PATH_MOODLE/lib" ]; then
        echo "Diretório lib não encontrado em $PATH_MOODLE"
        exit 1
    fi

}

detect_moodle_version() {

    local MOODLE_PATH="$1"
    local VERSION_FILE="$MOODLE_PATH/version.php"

    if [ ! -f "$VERSION_FILE" ]; then
        echo ""
        return
    fi

    local RELEASE

    RELEASE=$(grep "\$release" "$VERSION_FILE" | sed -E "s/.*'([^']+)'.*/\1/")

    echo "$RELEASE" | awk '{print $1}'

}