#!/usr/bin/env bash

source "$(dirname "$0")/../lib/config.sh"
source "$(dirname "$0")/../lib/utils.sh"
source "$(dirname "$0")/../lib/plugin-detect.sh"
source "$(dirname "$0")/../lib/generators.sh"
source "$(dirname "$0")/../lib/moodle-detect.sh"

echo "=== Moodle AI Plugin Context ==="
echo ""

PLUGIN_PATH="$1"

if [ -z "$PLUGIN_PATH" ]; then
    echo "Uso: moodle-ai plugin caminho/para/plugin"
    exit 1
fi

load_config

if [ -z "$MOODLE_PATH" ]; then
    read -p "Caminho da instalação Moodle: " MOODLE_PATH
fi

if [ -z "$MOODLE_VERSION" ]; then

    MOODLE_VERSION=$(detect_moodle_version "$MOODLE_PATH")

    if [ -z "$MOODLE_VERSION" ]; then
        read -p "Versão do Moodle: " MOODLE_VERSION
    fi

fi

echo ""

FULL_PLUGIN_PATH="$MOODLE_PATH/$PLUGIN_PATH"

if [ ! -d "$FULL_PLUGIN_PATH" ]; then
    echo "Plugin não encontrado: $FULL_PLUGIN_PATH"
    exit 1
fi

detect_plugin "$FULL_PLUGIN_PATH"

echo "Plugin detectado:"
echo "Nome: $PLUGIN_NAME"
echo "Tipo: $PLUGIN_TYPE"
echo "Caminho: $PLUGIN_PATH"
echo ""

read -p "Confirmar? (s/n): " CONFIRM

if [[ "$CONFIRM" != "s" && "$CONFIRM" != "S" ]]; then

    read -p "Nome do plugin: " PLUGIN_NAME
    read -p "Tipo do plugin: " PLUGIN_TYPE
    read -p "Caminho do plugin: " PLUGIN_PATH

    FULL_PLUGIN_PATH="$MOODLE_PATH/$PLUGIN_PATH"

fi

echo ""
echo "Gerando contexto do plugin..."
echo ""

# Contexto geral do plugin
generate_plugin_context "$MOODLE_PATH" "$PLUGIN_PATH"
generate_plugin_structure "$MOODLE_PATH" "$PLUGIN_PATH"
generate_plugin_events "$MOODLE_PATH" "$PLUGIN_PATH"
generate_plugin_db_tables "$MOODLE_PATH" "$PLUGIN_PATH"
generate_plugin_dependencies "$MOODLE_PATH" "$PLUGIN_PATH"

# Índices internos do plugin
generate_plugin_runtime_flow "$MOODLE_PATH" "$PLUGIN_PATH"
generate_plugin_function_index "$MOODLE_PATH" "$PLUGIN_PATH"
generate_plugin_callback_index "$MOODLE_PATH" "$PLUGIN_PATH"
generate_plugin_endpoint_index "$MOODLE_PATH" "$PLUGIN_PATH"

# Arquitetura
generate_plugin_architecture "$MOODLE_PATH" "$PLUGIN_PATH"

# Contexto final para IA
generate_plugin_ai_context "$MOODLE_PATH" "$PLUGIN_PATH"

# Marcar plugin como ativo
touch "$FULL_PLUGIN_PATH/.kaduvelasco"

# Atualizar índice global
generate_moodle_ai_index "$MOODLE_PATH"

echo ""
echo "Contexto do plugin gerado."
echo ""

echo "Arquivos criados:"
echo "$FULL_PLUGIN_PATH/PLUGIN_AI_CONTEXT.md"
echo "$FULL_PLUGIN_PATH/PLUGIN_ARCHITECTURE.md"
echo "$FULL_PLUGIN_PATH/PLUGIN_RUNTIME_FLOW.md"
echo ""