#!/usr/bin/env bash

source "$(dirname "$0")/../lib/utils.sh"
source "$(dirname "$0")/../lib/plugin-detect.sh"
source "$(dirname "$0")/../lib/generators.sh"

PLUGIN_PATH="$1"

if [ -z "$PLUGIN_PATH" ]; then
    echo "Uso: moodle-ai plugin caminho/para/plugin"
    exit 1
fi

read -p "Caminho da instalação Moodle: " MOODLE_PATH
read -p "Versão do Moodle: " MOODLE_VERSION

detect_plugin "$MOODLE_PATH/$PLUGIN_PATH"

echo ""
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

fi

generate_plugin_context "$MOODLE_PATH" "$PLUGIN_PATH"
generate_plugin_structure "$MOODLE_PATH" "$PLUGIN_PATH"
generate_plugin_events "$MOODLE_PATH" "$PLUGIN_PATH"
generate_plugin_db_tables "$MOODLE_PATH" "$PLUGIN_PATH"
generate_plugin_dependencies "$MOODLE_PATH" "$PLUGIN_PATH"

touch "$MOODLE_PATH/$PLUGIN_PATH/.kaduvelasco"

echo "Contexto do plugin gerado."
