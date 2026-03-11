#!/usr/bin/env bash

source "$(dirname "$0")/../lib/utils.sh"
source "$(dirname "$0")/../lib/moodle-detect.sh"
source "$(dirname "$0")/../lib/generators.sh"
source "$(dirname "$0")/../lib/indexers.sh"

echo "=== Moodle AI Init ==="

read -p "Caminho da instalação Moodle: " MOODLE_PATH
read -p "Versão do Moodle: " MOODLE_VERSION

check_moodle_install "$MOODLE_PATH"

echo "Gerando contexto global..."

generate_ai_context "$MOODLE_PATH" "$MOODLE_VERSION"
generate_moodle_plugin_guide "$MOODLE_PATH"
generate_moodle_dev_rules "$MOODLE_PATH"

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

generate_plugin_map "$MOODLE_PATH"

generate_moodle_ai_workspace "$MOODLE_PATH" "$MOODLE_VERSION"

generate_ctags "$MOODLE_PATH"

echo "Init concluído."
