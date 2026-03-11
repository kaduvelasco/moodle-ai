#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

########################################
# UTILS
########################################

safe_php_find() {

    find "$1" \
        -path "*/vendor/*" -prune -o \
        -path "*/node_modules/*" -prune -o \
        -name "*.php" -print
}

########################################
# MOODLE AI CONTEXT
########################################

generate_ai_context() {

    local MOODLE_PATH="$1"
    local MOODLE_VERSION="$2"

    local OUTPUT="$MOODLE_PATH/AI_CONTEXT.md"

    cat <<EOF > "$OUTPUT"
# Moodle AI Context

Version: $MOODLE_VERSION

Root structure:

mod/
local/
blocks/
admin/
auth/
course/
enrol/
grade/
theme/

This project is a Moodle installation.
EOF

}

########################################
# PLUGIN RUNTIME FLOW
########################################

generate_plugin_runtime_flow() {

    local PLUGIN_PATH="$1"
    local OUTPUT="$PLUGIN_PATH/PLUGIN_RUNTIME_FLOW.md"

    echo "Gerando PLUGIN_RUNTIME_FLOW.md..."

    cat "$BASE_DIR/templates/PLUGIN_RUNTIME_FLOW.md.tpl" > "$OUTPUT"

    echo "" >> "$OUTPUT"
    echo "## Entry Points" >> "$OUTPUT"

    find "$PLUGIN_PATH" -maxdepth 1 -name "*.php" \
        | while read FILE; do

        FILEBASE=$(basename "$FILE")

        case "$FILEBASE" in
            index.php|view.php|edit.php|manage.php|report.php|ajax.php)
                echo "- $FILEBASE" >> "$OUTPUT"
            ;;
        esac

    done

    echo "" >> "$OUTPUT"
    echo "## Core Logic" >> "$OUTPUT"

    for F in lib.php locallib.php; do
        if [ -f "$PLUGIN_PATH/$F" ]; then
            echo "- $F" >> "$OUTPUT"
        fi
    done

    echo "" >> "$OUTPUT"
    echo "## Classes" >> "$OUTPUT"

    if [ -d "$PLUGIN_PATH/classes" ]; then
        find "$PLUGIN_PATH/classes" -name "*.php" \
            | sed "s|$PLUGIN_PATH/||" \
            | sort \
            | while read CLASS; do
                echo "- $CLASS" >> "$OUTPUT"
            done
    fi

    echo "" >> "$OUTPUT"
    echo "## Events" >> "$OUTPUT"

    if [ -f "$PLUGIN_PATH/db/events.php" ]; then
        grep -oP "'eventname'\s*=>\s*'[^']+'" "$PLUGIN_PATH/db/events.php" \
            | sed "s/'eventname' => '//" \
            | sed "s/'//" \
            | sort -u \
            | while read EVENT; do
                echo "- $EVENT" >> "$OUTPUT"
            done
    fi

    echo "" >> "$OUTPUT"
    echo "## Tasks" >> "$OUTPUT"

    if [ -f "$PLUGIN_PATH/db/tasks.php" ]; then
        grep -oP "'classname'\s*=>\s*'[^']+'" "$PLUGIN_PATH/db/tasks.php" \
            | sed "s/'classname' => '//" \
            | sed "s/'//" \
            | sort -u \
            | while read TASK; do
                echo "- $TASK" >> "$OUTPUT"
            done
    fi

    echo "" >> "$OUTPUT"
    echo "## Web Services" >> "$OUTPUT"

    if [ -f "$PLUGIN_PATH/db/services.php" ]; then
        grep -oP "'methodname'\s*=>\s*'[^']+'" "$PLUGIN_PATH/db/services.php" \
            | sed "s/'methodname' => '//" \
            | sed "s/'//" \
            | sort -u \
            | while read SERVICE; do
                echo "- $SERVICE" >> "$OUTPUT"
            done
    fi

}

########################################
# PLUGIN FUNCTION INDEX
########################################

generate_plugin_function_index() {

    local PLUGIN_PATH="$1"
    local OUTPUT="$PLUGIN_PATH/PLUGIN_FUNCTION_INDEX.md"

    echo "Gerando PLUGIN_FUNCTION_INDEX.md..."

    cat "$BASE_DIR/templates/PLUGIN_FUNCTION_INDEX.md.tpl" > "$OUTPUT"

    echo "" >> "$OUTPUT"

    safe_php_find "$PLUGIN_PATH" \
        | while read FILE; do

        REL=$(echo "$FILE" | sed "s|$PLUGIN_PATH/||")

        echo "### $REL" >> "$OUTPUT"

        grep -oP 'function\s+\w+\(' "$FILE" \
            | sed 's/function //' \
            | sed 's/(//' \
            | sort -u \
            | while read FUNC; do
                echo "- $FUNC()" >> "$OUTPUT"
            done

        echo "" >> "$OUTPUT"

    done

}

########################################
# PLUGIN CALLBACK INDEX
########################################

generate_plugin_callback_index() {

    local PLUGIN_PATH="$1"
    local OUTPUT="$PLUGIN_PATH/PLUGIN_CALLBACK_INDEX.md"

    echo "Gerando PLUGIN_CALLBACK_INDEX.md..."

    cat "$BASE_DIR/templates/PLUGIN_CALLBACK_INDEX.md.tpl" > "$OUTPUT"

    echo "" >> "$OUTPUT"

    PLUGIN_DIR=$(basename "$PLUGIN_PATH")
    PLUGIN_TYPE=$(basename "$(dirname "$PLUGIN_PATH")")

    PREFIX="${PLUGIN_TYPE}_${PLUGIN_DIR}_"

    for FILE in "$PLUGIN_PATH/lib.php" "$PLUGIN_PATH/locallib.php"; do

        if [ -f "$FILE" ]; then

            grep -oP "function\s+${PREFIX}\w+\(" "$FILE" \
                | sed 's/function //' \
                | sed 's/(//' \
                | sort -u \
                | while read CALLBACK; do
                    echo "- ${CALLBACK}()" >> "$OUTPUT"
                done

        fi

    done

}

########################################
# PLUGIN ENDPOINT INDEX
########################################

generate_plugin_endpoint_index() {

    local PLUGIN_PATH="$1"
    local OUTPUT="$PLUGIN_PATH/PLUGIN_ENDPOINT_INDEX.md"

    echo "Gerando PLUGIN_ENDPOINT_INDEX.md..."

    cat "$BASE_DIR/templates/PLUGIN_ENDPOINT_INDEX.md.tpl" > "$OUTPUT"

    echo "" >> "$OUTPUT"
    echo "## Web Services" >> "$OUTPUT"

    if [ -f "$PLUGIN_PATH/db/services.php" ]; then
        grep -oP "'methodname'\s*=>\s*'[^']+'" "$PLUGIN_PATH/db/services.php" \
            | sed "s/'methodname' => '//" \
            | sed "s/'//" \
            | sort -u \
            | while read SERVICE; do
                echo "- $SERVICE" >> "$OUTPUT"
            done
    fi

    echo "" >> "$OUTPUT"
    echo "## AJAX Endpoints" >> "$OUTPUT"

    find "$PLUGIN_PATH" -maxdepth 2 -name "ajax.php" \
        | sed "s|$PLUGIN_PATH/||" \
        | while read FILE; do
            echo "- $FILE" >> "$OUTPUT"
        done

    echo "" >> "$OUTPUT"
    echo "## AMD Modules" >> "$OUTPUT"

    if [ -d "$PLUGIN_PATH/amd/src" ]; then
        find "$PLUGIN_PATH/amd/src" -name "*.js" \
            | sed "s|$PLUGIN_PATH/||" \
            | while read FILE; do
                MODULE=$(basename "$FILE" .js)
                echo "- $MODULE" >> "$OUTPUT"
            done
    fi

}

########################################
# PLUGIN ARCHITECTURE
########################################

generate_plugin_architecture() {

    local PLUGIN_PATH="$1"
    local OUTPUT="$PLUGIN_PATH/PLUGIN_ARCHITECTURE.md"

    echo "Gerando PLUGIN_ARCHITECTURE.md..."

    cat "$BASE_DIR/templates/PLUGIN_ARCHITECTURE.md.tpl" > "$OUTPUT"

    PLUGIN_NAME=$(basename "$PLUGIN_PATH")
    PLUGIN_TYPE=$(basename "$(dirname "$PLUGIN_PATH"))

    echo "" >> "$OUTPUT"
    echo "## Plugin Information" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    echo "- Name: $PLUGIN_NAME" >> "$OUTPUT"
    echo "- Type: $PLUGIN_TYPE" >> "$OUTPUT"
    echo "- Path: $PLUGIN_PATH" >> "$OUTPUT"

}

########################################
# PLUGIN AI CONTEXT
########################################

generate_plugin_ai_context() {

    local PLUGIN_PATH="$1"
    local OUTPUT="$PLUGIN_PATH/PLUGIN_AI_CONTEXT.md"

    echo "Gerando PLUGIN_AI_CONTEXT.md..."

    cat "$BASE_DIR/templates/PLUGIN_AI_CONTEXT.md.tpl" > "$OUTPUT"

    PLUGIN_NAME=$(basename "$PLUGIN_PATH")
    PLUGIN_TYPE=$(basename "$(dirname "$PLUGIN_PATH"))

    sed -i "s|Name:|Name: $PLUGIN_NAME|" "$OUTPUT"
    sed -i "s|Type:|Type: $PLUGIN_TYPE|" "$OUTPUT"
    sed -i "s|Path:|Path: $PLUGIN_PATH|" "$OUTPUT"

    echo "" >> "$OUTPUT"

    safe_php_find "$PLUGIN_PATH" \
        | while read FILE; do

        grep -oP 'function\s+\w+\(' "$FILE" \
            | sed 's/function //' \
            | sed 's/(//' 

    done | sort -u \
        | while read FUNC; do
            echo "- $FUNC()" >> "$OUTPUT"
        done

}

########################################
# MOODLE AI WORKSPACE
########################################

generate_moodle_ai_workspace() {

    local MOODLE_PATH="$1"
    local MOODLE_VERSION="$2"
    local OUTPUT="$MOODLE_PATH/MOODLE_AI_WORKSPACE.md"

    echo "Gerando MOODLE_AI_WORKSPACE.md..."

    cat "$BASE_DIR/templates/MOODLE_AI_WORKSPACE.md.tpl" > "$OUTPUT"

    sed -i "s|Version:|Version: $MOODLE_VERSION|" "$OUTPUT"
    sed -i "s|Path:|Path: $MOODLE_PATH|" "$OUTPUT"

}

########################################
# MOODLE AI GLOBAL INDEX
########################################

generate_moodle_ai_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_AI_INDEX.md"

    echo "Gerando MOODLE_AI_INDEX.md..."

    cat "$BASE_DIR/templates/MOODLE_AI_INDEX.md.tpl" > "$OUTPUT"

    echo "" >> "$OUTPUT"
    echo "## Core Moodle Indexes" >> "$OUTPUT"
    echo "" >> "$OUTPUT"

    for FILE in \
        MOODLE_API_INDEX.md \
        MOODLE_EVENTS_INDEX.md \
        MOODLE_TASKS_INDEX.md \
        MOODLE_SERVICES_INDEX.md \
        MOODLE_DB_TABLES_INDEX.md \
        MOODLE_CLASSES_INDEX.md \
        MOODLE_CALLBACKS_INDEX.md \
        MOODLE_PLUGIN_TYPES.md \
        MOODLE_SUBSYSTEMS_INDEX.md \
        MOODLE_CAPABILITIES_INDEX.md \
        MOODLE_DATABASE_SCHEMA.md \
        MOODLE_PLUGIN_DEPENDENCIES.md \
        MOODLE_PLUGIN_FILE_INDEX.md
    do

        if [ -f "$MOODLE_PATH/$FILE" ]; then
            echo "- [$FILE]($FILE)" >> "$OUTPUT"
        fi

    done

    echo "" >> "$OUTPUT"
    echo "## AI Workspace" >> "$OUTPUT"
    echo "" >> "$OUTPUT"

    if [ -f "$MOODLE_PATH/MOODLE_AI_WORKSPACE.md" ]; then
        echo "- [MOODLE_AI_WORKSPACE.md](MOODLE_AI_WORKSPACE.md)" >> "$OUTPUT"
    fi

    if [ -f "$MOODLE_PATH/AI_CONTEXT.md" ]; then
        echo "- [AI_CONTEXT.md](AI_CONTEXT.md)" >> "$OUTPUT"
    fi

    echo "" >> "$OUTPUT"
    echo "## Plugins With AI Context" >> "$OUTPUT"
    echo "" >> "$OUTPUT"

    find "$MOODLE_PATH" -name "PLUGIN_AI_CONTEXT.md" \
        | while read FILE; do

            REL=$(echo "$FILE" | sed "s|$MOODLE_PATH/||")

            echo "- [$REL]($REL)" >> "$OUTPUT"

        done

}