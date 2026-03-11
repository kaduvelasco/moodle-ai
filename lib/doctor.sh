#!/usr/bin/env bash

check_system_dependencies() {

    local DEPS=("grep" "sed" "awk" "find" "ctags")

    for DEP in "${DEPS[@]}"; do

        if command -v "$DEP" >/dev/null 2>&1; then
            echo "✔ $DEP encontrado"
        else
            echo "✖ $DEP não encontrado"
        fi

    done

}

check_moodle_indexes() {

    local MOODLE_PATH="$1"

    local FILES=(
        MOODLE_API_INDEX.md
        MOODLE_EVENTS_INDEX.md
        MOODLE_TASKS_INDEX.md
        MOODLE_SERVICES_INDEX.md
        MOODLE_DB_TABLES_INDEX.md
        MOODLE_CLASSES_INDEX.md
        MOODLE_CALLBACKS_INDEX.md
        MOODLE_PLUGIN_TYPES.md
        MOODLE_SUBSYSTEMS_INDEX.md
        MOODLE_CAPABILITIES_INDEX.md
        MOODLE_DATABASE_SCHEMA.md
        MOODLE_PLUGIN_DEPENDENCIES.md
        MOODLE_PLUGIN_FILE_INDEX.md
        MOODLE_AI_INDEX.md
        MOODLE_AI_WORKSPACE.md
    )

    for FILE in "${FILES[@]}"; do

        if [ -f "$MOODLE_PATH/$FILE" ]; then
            echo "✔ $FILE"
        else
            echo "✖ $FILE ausente"
        fi

    done

}

check_plugins_marked() {

    local MOODLE_PATH="$1"

    COUNT=$(find "$MOODLE_PATH" -name ".kaduvelasco" | wc -l)

    if [ "$COUNT" -eq 0 ]; then
        echo "Nenhum plugin marcado com .kaduvelasco"
        return
    fi

    echo "$COUNT plugins marcados"

    find "$MOODLE_PATH" -name ".kaduvelasco" | while read FILE; do

        PLUGIN_DIR=$(dirname "$FILE")

        if [ -f "$PLUGIN_DIR/PLUGIN_AI_CONTEXT.md" ]; then
            echo "✔ $(basename "$PLUGIN_DIR")"
        else
            echo "✖ $(basename "$PLUGIN_DIR") sem contexto AI"
        fi

    done

}

check_ai_workspace() {

    local MOODLE_PATH="$1"

    if [ -f "$MOODLE_PATH/MOODLE_AI_WORKSPACE.md" ]; then
        echo "✔ AI Workspace encontrado"
    else
        echo "✖ AI Workspace ausente"
    fi

}