#!/usr/bin/env bash

source "$(dirname "$0")/../lib/config.sh"

PLUGIN_PATH="$1"

if [ -z "$MOODLE_PATH" ]; then
    echo "Configuração não encontrada. Execute:"
    echo "moodle-ai init"
    exit 1
fi

if [ -z "$PLUGIN_PATH" ]; then
    echo "Uso: moodle-ai explain caminho/plugin"
    exit 1
fi

load_config

PLUGIN_DIR="$MOODLE_PATH/$PLUGIN_PATH"

if [ ! -d "$PLUGIN_DIR" ]; then
    echo "Plugin não encontrado: $PLUGIN_DIR"
    exit 1
fi

echo "=== Plugin Explanation ==="
echo ""

echo "Plugin:"
echo "$PLUGIN_PATH"
echo ""

echo "Arquitetura:"
echo "----------------"

if [ -f "$PLUGIN_DIR/PLUGIN_ARCHITECTURE.md" ]; then
    head -n 40 "$PLUGIN_DIR/PLUGIN_ARCHITECTURE.md"
fi

echo ""

echo "Runtime Flow:"
echo "----------------"

if [ -f "$PLUGIN_DIR/PLUGIN_RUNTIME_FLOW.md" ]; then
    head -n 40 "$PLUGIN_DIR/PLUGIN_RUNTIME_FLOW.md"
fi

echo ""

echo "Funções:"
echo "----------------"

if [ -f "$PLUGIN_DIR/PLUGIN_FUNCTION_INDEX.md" ]; then
    head -n 20 "$PLUGIN_DIR/PLUGIN_FUNCTION_INDEX.md"
fi

echo ""

echo "Callbacks:"
echo "----------------"

if [ -f "$PLUGIN_DIR/PLUGIN_CALLBACK_INDEX.md" ]; then
    head -n 20 "$PLUGIN_DIR/PLUGIN_CALLBACK_INDEX.md"
fi

echo ""

echo "Endpoints:"
echo "----------------"

if [ -f "$PLUGIN_DIR/PLUGIN_ENDPOINT_INDEX.md" ]; then
    head -n 20 "$PLUGIN_DIR/PLUGIN_ENDPOINT_INDEX.md"
fi