#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

COMMAND="$1"
shift || true

show_help() {
    echo ""
    echo "Moodle AI Tools"
    echo ""
    echo "Usage:"
    echo "  moodle-ai init"
    echo "      Inicializa o contexto de IA para uma instalação do Moodle."
    echo ""
    echo "  moodle-ai plugin <plugin_path>"
    echo "      Gera contexto de IA para um plugin específico."
    echo ""
    echo "  moodle-ai update"
    echo "      Atualiza índices e contextos existentes."
    echo ""
    echo "Examples:"
    echo "  moodle-ai init"
    echo "  moodle-ai plugin local/meuplugin"
    echo "  moodle-ai update"
    echo ""
}

case "$COMMAND" in

    init)
        "$BASE_DIR/commands/init.sh" "$@"
        ;;

    plugin)
        "$BASE_DIR/commands/plugin.sh" "$@"
        ;;

    update)
        "$BASE_DIR/commands/update.sh" "$@"
        ;;

    help|-h|--help|"")
        show_help
        ;;

    *)
        echo "Comando desconhecido: $COMMAND"
        show_help
        exit 1
        ;;

esac
