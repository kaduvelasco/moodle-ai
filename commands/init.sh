#!/usr/bin/env bash

source "$(dirname "$0")/../lib/config.sh"
source "$(dirname "$0")/../lib/utils.sh"
source "$(dirname "$0")/../lib/moodle-detect.sh"
source "$(dirname "$0")/../lib/generators.sh"
source "$(dirname "$0")/../lib/indexers.sh"

echo "=== Moodle AI Init ==="
echo ""

load_config

if [ -z "$MOODLE_PATH" ]; then
    read -p "Caminho da instalação Moodle: " MOODLE_PATH
fi

if [ -z "$MOODLE_VERSION" ]; then

    echo "Detectando versão do Moodle..."

    MOODLE_VERSION=$(detect_moodle_version "$MOODLE_PATH")

    if [ -n "$MOODLE_VERSION" ]; then
        echo "Versão detectada: $MOODLE_VERSION"
    else
        read -p "Versão do Moodle: " MOODLE_VERSION
    fi

fi

save_config "$MOODLE_PATH" "$MOODLE_VERSION"

echo ""

check_moodle_install "$MOODLE_PATH"

echo "Gerando contexto global..."
echo ""

# Contexto base
generate_ai_context "$MOODLE_PATH" "$MOODLE_VERSION"
generate_moodle_plugin_guide "$MOODLE_PATH"
generate_moodle_dev_rules "$MOODLE_PATH"

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

# Workspace da IA
generate_moodle_ai_workspace "$MOODLE_PATH" "$MOODLE_VERSION"

# Indexação de código
generate_ctags "$MOODLE_PATH"

# Índice global
generate_moodle_ai_index "$MOODLE_PATH"

echo ""
echo "Init concluído."
echo ""
echo "Arquivos principais gerados:"
echo "$MOODLE_PATH/MOODLE_AI_INDEX.md"
echo "$MOODLE_PATH/MOODLE_AI_WORKSPACE.md"
echo ""