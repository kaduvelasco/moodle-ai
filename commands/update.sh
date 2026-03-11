#!/usr/bin/env bash

source "$(dirname "$0")/../lib/config.sh"
source "$(dirname "$0")/../lib/utils.sh"
source "$(dirname "$0")/../lib/indexers.sh"
source "$(dirname "$0")/../lib/generators.sh"
source "$(dirname "$0")/../lib/moodle-detect.sh"

echo "=== Moodle AI Update ==="
echo ""

load_config

if [ -z "$MOODLE_PATH" ]; then
    read -p "Caminho da instalação Moodle: " MOODLE_PATH
fi

if [ -z "$MOODLE_VERSION" ]; then
    MOODLE_VERSION=$(detect_moodle_version "$MOODLE_PATH")
fi

echo ""
echo "Atualizando índices..."
echo ""

# Índices do Moodle
generate_api_index "$MOODLE_PATH"
generate_events_index "$MOODLE_PATH"
generate_tasks_index "$MOODLE_PATH"
generate_services_index "$MOODLE_PATH"
generate_db_tables_index "$MOODLE_PATH"
generate_classes_index "$MOODLE_PATH"
generate_callbacks_index "$MOODLE_PATH"
generate_plugin_types_index "$MOODLE_PATH"
generate_subsystems_index "$MOODLE_PATH"
generate_capabilities_index "$MOODLE_PATH"
generate_database_schema "$MOODLE_PATH"
generate_plugin_dependencies_index "$MOODLE_PATH"
generate_plugin_file_index "$MOODLE_PATH"

# Estrutura geral
generate_plugin_map "$MOODLE_PATH"
generate_plugin_index "$MOODLE_PATH"

# Indexação de código
generate_ctags "$MOODLE_PATH"

# Atualizar índice global
generate_moodle_ai_index "$MOODLE_PATH"

echo ""
echo "Update concluído."
echo ""

echo "Arquivo principal atualizado:"
echo "$MOODLE_PATH/MOODLE_AI_INDEX.md"
echo ""