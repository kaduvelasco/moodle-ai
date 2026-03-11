#!/usr/bin/env bash

validate_path() {

    local PATH_TEST="$1"

    if [ -z "$PATH_TEST" ]; then
        echo "Caminho não informado"
        exit 1
    fi

    if [ ! -d "$PATH_TEST" ]; then
        echo "Caminho inválido: $PATH_TEST"
        exit 1
    fi

}