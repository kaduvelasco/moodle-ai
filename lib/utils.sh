#!/usr/bin/env bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}$1${NC}"
}

log_warn() {
    echo -e "${YELLOW}$1${NC}"
}

log_error() {
    echo -e "${RED}$1${NC}"
}

log_step() {
    echo -e "${BLUE}$1${NC}"
}

log_success() {
    echo -e "${GREEN}✔ $1${NC}"
}

log_fail() {
    echo -e "${RED}✖ $1${NC}"
}

write_template() {

    local TEMPLATE="$1"
    local OUTPUT="$2"

    cat "$TEMPLATE" > "$OUTPUT"
    printf "\n" >> "$OUTPUT"
}

ask() {
    read -p "$1: " value
    echo "$value"
}