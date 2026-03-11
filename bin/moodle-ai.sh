#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMMAND_DIR="$BASE_DIR/commands"

VERSION="2.1.0"

COMMAND="${1:-help}"
shift || true

show_help() {

    echo ""
    echo "Moodle AI Tools v$VERSION"
    echo ""
    echo "Usage:"
    echo "  moodle-ai <command>"
    echo ""
    echo "Commands:"
    echo "  init"
    echo "      Initialize AI context for a Moodle installation."
    echo ""
    echo "  plugin <plugin_path>"
    echo "      Generate AI context for a specific plugin."
    echo ""
    echo "  update"
    echo "      Update indexes and generated contexts."
    echo ""
    echo "  doctor"
    echo "      Check Moodle environment and moodle-ai configuration."
    echo ""
    echo "  explain <plugin_path>"
    echo "      Explain the architecture of a Moodle plugin."
    echo ""
    echo "  list-plugins"
    echo "      List all detected Moodle plugins."
    echo ""
    echo "  search <text>"
    echo "      Search plugins in the plugin index."
    echo ""
    echo "  help"
    echo "      Show this help."
    echo ""
    echo "  version"
    echo "      Show tool version."
    echo ""
    echo "Examples:"
    echo "  moodle-ai init"
    echo "  moodle-ai plugin local/myplugin"
    echo "  moodle-ai update"
    echo "  moodle-ai doctor"
    echo "  moodle-ai explain local/myplugin"
    echo ""
}

case "$COMMAND" in

    init|-i|--init)
        "$COMMAND_DIR/init.sh" "$@"
        ;;

    plugin|-p|--plugin)
        "$COMMAND_DIR/plugin.sh" "$@"
        ;;

    update|-u|--update)
        "$COMMAND_DIR/update.sh" "$@"
        ;;

    doctor|-d|--doctor)
        "$COMMAND_DIR/doctor.sh" "$@"
        ;;

    explain|-e|--explain)
        "$COMMAND_DIR/explain.sh" "$@"
        ;;

    list-plugins|--list-plugins)
        "$COMMAND_DIR/list-plugins.sh" "$@"
        ;;

    search|--search)
        "$COMMAND_DIR/search.sh" "$@"
        ;;    

    help|-h|--help)
        show_help
        ;;

    version|-v|--version)
        echo "moodle-ai version $VERSION"
        ;;

    *)
        echo "Unknown command: $COMMAND"
        echo ""
        show_help
        exit 1
        ;;

esac