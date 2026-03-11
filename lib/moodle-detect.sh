#!/usr/bin/env bash

check_moodle_install() {

    local PATH_MOODLE="$1"

    if [ ! -f "$PATH_MOODLE/version.php" ]; then
        echo "version.php não encontrado"
        exit 1
    fi

    if [ ! -d "$PATH_MOODLE/lib" ]; then
        echo "Diretório lib não encontrado"
        exit 1
    fi

}
