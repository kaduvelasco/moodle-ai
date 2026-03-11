#!/usr/bin/env bash

source "$(dirname "$0")/../lib/utils.sh"
source "$(dirname "$0")/../lib/moodle-detect.sh"
source "$(dirname "$0")/../lib/doctor.sh"

echo "=== Moodle AI Doctor ==="
echo ""

read -p "Caminho da instalação Moodle: " MOODLE_PATH

echo ""

check_moodle_install "$MOODLE_PATH"

echo ""
log_step "Verificando dependências do sistema..."
check_system_dependencies

echo ""
log_step "Verificando índices Moodle..."
check_moodle_indexes "$MOODLE_PATH"

echo ""
log_step "Verificando plugins marcados..."
check_plugins_marked "$MOODLE_PATH"

echo ""
log_step "Verificando contexto AI..."
check_ai_workspace "$MOODLE_PATH"

echo ""
log_info "Diagnóstico concluído."
echo ""