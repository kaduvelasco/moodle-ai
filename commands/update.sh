#!/usr/bin/env bash

source "$(dirname "$0")/../lib/utils.sh"
source "$(dirname "$0")/../lib/indexers.sh"
source "$(dirname "$0")/../lib/generators.sh"

echo "=== Moodle AI Update ==="

read -p "Caminho da instalação Moodle: " MOODLE_PATH

echo "Atualizando índices..."

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

generate_plugin_map "$MOODLE_PATH"

generate_ctags "$MOODLE_PATH"

echo "Update concluído."
