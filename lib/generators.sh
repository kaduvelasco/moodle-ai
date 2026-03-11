#!/usr/bin/env bash

generate_ai_context() {

    local MOODLE_PATH="$1"
    local MOODLE_VERSION="$2"

    OUTPUT="$MOODLE_PATH/AI_CONTEXT.md"

    cat <<EOF > "$OUTPUT"
# Moodle AI Context

Version: $MOODLE_VERSION

Root structure:

mod/
local/
blocks/
admin/

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
                index.php|view.php|edit.php|manage.php|report.php)
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

    ########################################
    # lib.php
    ########################################

    if [ -f "$PLUGIN_PATH/lib.php" ]; then

        echo "### lib.php" >> "$OUTPUT"

        grep -oP 'function\s+\w+\(' "$PLUGIN_PATH/lib.php" \
            | sed 's/function //' \
            | sed 's/(//' \
            | while read FUNC; do
                echo "- $FUNC()" >> "$OUTPUT"
            done

        echo "" >> "$OUTPUT"
    fi

    ########################################
    # locallib.php
    ########################################

    if [ -f "$PLUGIN_PATH/locallib.php" ]; then

        echo "### locallib.php" >> "$OUTPUT"

        grep -oP 'function\s+\w+\(' "$PLUGIN_PATH/locallib.php" \
            | sed 's/function //' \
            | sed 's/(//' \
            | while read FUNC; do
                echo "- $FUNC()" >> "$OUTPUT"
            done

        echo "" >> "$OUTPUT"
    fi

    ########################################
    # classes
    ########################################

    if [ -d "$PLUGIN_PATH/classes" ]; then

        find "$PLUGIN_PATH/classes" -name "*.php" | while read FILE; do

            REL=$(echo "$FILE" | sed "s|$PLUGIN_PATH/||")

            echo "### $REL" >> "$OUTPUT"

            grep -oP 'function\s+\w+\(' "$FILE" \
                | sed 's/function //' \
                | sed 's/(//' \
                | while read FUNC; do
                    echo "- $FUNC()" >> "$OUTPUT"
                done

            echo "" >> "$OUTPUT"

        done

    fi

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

    # detectar tipo e nome do plugin
    PLUGIN_DIR=$(basename "$PLUGIN_PATH")
    PLUGIN_TYPE=$(basename "$(dirname "$PLUGIN_PATH")")

    PREFIX="${PLUGIN_TYPE}_${PLUGIN_DIR}_"

    ########################################
    # procurar callbacks em lib.php e locallib.php
    ########################################

    for FILE in "$PLUGIN_PATH/lib.php" "$PLUGIN_PATH/locallib.php"; do

        if [ -f "$FILE" ]; then

            grep -oP "function\s+${PREFIX}\w+\(" "$FILE" \
                | sed 's/function //' \
                | sed 's/(//' \
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

    ########################################
    # Web Services
    ########################################

    echo "" >> "$OUTPUT"
    echo "## Web Services" >> "$OUTPUT"

    if [ -f "$PLUGIN_PATH/db/services.php" ]; then

        grep -oP "'methodname'\s*=>\s*'[^']+'" "$PLUGIN_PATH/db/services.php" \
            | sed "s/'methodname' => '//" \
            | sed "s/'//" \
            | while read SERVICE; do
                echo "- $SERVICE" >> "$OUTPUT"
            done

    else
        echo "- Nenhum webservice encontrado" >> "$OUTPUT"
    fi

    ########################################
    # External API classes
    ########################################

    echo "" >> "$OUTPUT"
    echo "## External API Classes" >> "$OUTPUT"

    if [ -d "$PLUGIN_PATH/classes/external" ]; then

        find "$PLUGIN_PATH/classes/external" -name "*.php" \
            | sed "s|$PLUGIN_PATH/||" \
            | while read FILE; do
                echo "- $FILE" >> "$OUTPUT"
            done

    else
        echo "- Nenhuma external API class encontrada" >> "$OUTPUT"
    fi

    ########################################
    # AJAX endpoints
    ########################################

    echo "" >> "$OUTPUT"
    echo "## AJAX Endpoints" >> "$OUTPUT"

    find "$PLUGIN_PATH" -maxdepth 2 -name "ajax.php" \
        | sed "s|$PLUGIN_PATH/||" \
        | while read FILE; do
            echo "- $FILE" >> "$OUTPUT"
        done

    ########################################
    # AMD modules
    ########################################

    echo "" >> "$OUTPUT"
    echo "## AMD Modules" >> "$OUTPUT"

    if [ -d "$PLUGIN_PATH/amd/src" ]; then

        find "$PLUGIN_PATH/amd/src" -name "*.js" \
            | sed "s|$PLUGIN_PATH/||" \
            | while read FILE; do
                MODULE=$(basename "$FILE" .js)
                echo "- $MODULE" >> "$OUTPUT"
            done

    else
        echo "- Nenhum módulo AMD encontrado" >> "$OUTPUT"
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

    ########################################
    # Main files
    ########################################

    echo "" >> "$OUTPUT"
    echo "## Main Files" >> "$OUTPUT"

    for FILE in version.php lib.php locallib.php settings.php; do
        if [ -f "$PLUGIN_PATH/$FILE" ]; then
            echo "- $FILE" >> "$OUTPUT"
        fi
    done

    ########################################
    # Database
    ########################################

    echo "" >> "$OUTPUT"
    echo "## Database" >> "$OUTPUT"

    if [ -f "$PLUGIN_PATH/db/install.xml" ]; then

        grep -oP '<TABLE NAME="[^"]+"' "$PLUGIN_PATH/db/install.xml" \
            | sed 's/<TABLE NAME="//' \
            | sed 's/"//' \
            | while read TABLE; do
                echo "- $TABLE" >> "$OUTPUT"
            done

    else
        echo "- No database tables" >> "$OUTPUT"
    fi

    ########################################
    # Events
    ########################################

    echo "" >> "$OUTPUT"
    echo "## Events" >> "$OUTPUT"

    if [ -f "$PLUGIN_PATH/db/events.php" ]; then

        grep -oP "'eventname'\s*=>\s*'[^']+'" "$PLUGIN_PATH/db/events.php" \
            | sed "s/'eventname' => '//" \
            | sed "s/'//" \
            | while read EVENT; do
                echo "- $EVENT" >> "$OUTPUT"
            done

    else
        echo "- No events" >> "$OUTPUT"
    fi

    ########################################
    # Callbacks
    ########################################

    echo "" >> "$OUTPUT"
    echo "## Callbacks" >> "$OUTPUT"

    PREFIX="${PLUGIN_TYPE}_${PLUGIN_NAME}_"

    for FILE in "$PLUGIN_PATH/lib.php" "$PLUGIN_PATH/locallib.php"; do

        if [ -f "$FILE" ]; then

            grep -oP "function\s+${PREFIX}\w+\(" "$FILE" \
                | sed 's/function //' \
                | sed 's/(//' \
                | while read CALLBACK; do
                    echo "- ${CALLBACK}()" >> "$OUTPUT"
                done

        fi

    done

    ########################################
    # Endpoints
    ########################################

    echo "" >> "$OUTPUT"
    echo "## Endpoints" >> "$OUTPUT"

    if [ -f "$PLUGIN_PATH/db/services.php" ]; then

        grep -oP "'methodname'\s*=>\s*'[^']+'" "$PLUGIN_PATH/db/services.php" \
            | sed "s/'methodname' => '//" \
            | sed "s/'//" \
            | while read SERVICE; do
                echo "- $SERVICE" >> "$OUTPUT"
            done

    else
        echo "- No endpoints" >> "$OUTPUT"
    fi

    ########################################
    # Runtime Flow
    ########################################

    echo "" >> "$OUTPUT"
    echo "## Runtime Flow" >> "$OUTPUT"

    find "$PLUGIN_PATH" -maxdepth 1 -name "*.php" \
        | sed "s|$PLUGIN_PATH/||" \
        | while read FILE; do
            echo "- $FILE" >> "$OUTPUT"
        done

    ########################################
    # Notes
    ########################################

    echo "" >> "$OUTPUT"
    echo "## Notes" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    echo "Arquitetura gerada automaticamente pelo moodle-ai." >> "$OUTPUT"

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

    ########################################
    # Plugin info
    ########################################

    sed -i "s|Name:|Name: $PLUGIN_NAME|" "$OUTPUT"
    sed -i "s|Type:|Type: $PLUGIN_TYPE|" "$OUTPUT"
    sed -i "s|Path:|Path: $PLUGIN_PATH|" "$OUTPUT"

    ########################################
    # Main files
    ########################################

    echo "" >> "$OUTPUT"
    for FILE in version.php lib.php locallib.php settings.php; do
        if [ -f "$PLUGIN_PATH/$FILE" ]; then
            echo "- $FILE" >> "$OUTPUT"
        fi
    done

    ########################################
    # Database tables
    ########################################

    if [ -f "$PLUGIN_PATH/db/install.xml" ]; then

        echo "" >> "$OUTPUT"

        grep -oP '<TABLE NAME="[^"]+"' "$PLUGIN_PATH/db/install.xml" \
            | sed 's/<TABLE NAME="//' \
            | sed 's/"//' \
            | while read TABLE; do
                echo "- $TABLE" >> "$OUTPUT"
            done

    fi

    ########################################
    # Events
    ########################################

    if [ -f "$PLUGIN_PATH/db/events.php" ]; then

        echo "" >> "$OUTPUT"

        grep -oP "'eventname'\s*=>\s*'[^']+'" "$PLUGIN_PATH/db/events.php" \
            | sed "s/'eventname' => '//" \
            | sed "s/'//" \
            | while read EVENT; do
                echo "- $EVENT" >> "$OUTPUT"
            done

    fi

    ########################################
    # Callbacks
    ########################################

    PREFIX="${PLUGIN_TYPE}_${PLUGIN_NAME}_"

    for FILE in "$PLUGIN_PATH/lib.php" "$PLUGIN_PATH/locallib.php"; do

        if [ -f "$FILE" ]; then

            grep -oP "function\s+${PREFIX}\w+\(" "$FILE" \
                | sed 's/function //' \
                | sed 's/(//' \
                | while read CALLBACK; do
                    echo "- ${CALLBACK}()" >> "$OUTPUT"
                done

        fi

    done

    ########################################
    # Functions
    ########################################

    find "$PLUGIN_PATH" -name "*.php" \
        | while read FILE; do

            grep -oP 'function\s+\w+\(' "$FILE" \
                | sed 's/function //' \
                | sed 's/(//' \
                | while read FUNC; do
                    echo "- $FUNC()" >> "$OUTPUT"
                done

        done | sort -u >> "$OUTPUT"

    ########################################
    # Endpoints
    ########################################

    if [ -f "$PLUGIN_PATH/db/services.php" ]; then

        grep -oP "'methodname'\s*=>\s*'[^']+'" "$PLUGIN_PATH/db/services.php" \
            | sed "s/'methodname' => '//" \
            | sed "s/'//" \
            | while read SERVICE; do
                echo "- $SERVICE" >> "$OUTPUT"
            done

    fi

    ########################################
    # Runtime entrypoints
    ########################################

    find "$PLUGIN_PATH" -maxdepth 1 -name "*.php" \
        | sed "s|$PLUGIN_PATH/||" \
        | while read FILE; do
            echo "- $FILE" >> "$OUTPUT"
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

    ########################################
    # Moodle info
    ########################################

    sed -i "s|Version:|Version: $MOODLE_VERSION|" "$OUTPUT"
    sed -i "s|Path:|Path: $MOODLE_PATH|" "$OUTPUT"

    ########################################
    # Plugin types
    ########################################

    echo "" >> "$OUTPUT"
    echo "## Core Plugin Types" >> "$OUTPUT"

    for DIR in "$MOODLE_PATH"/*; do

        if [ -d "$DIR" ]; then

            NAME=$(basename "$DIR")

            if [ -f "$DIR/version.php" ] || [ -d "$DIR/db" ]; then
                echo "- $NAME" >> "$OUTPUT"
            fi

        fi

    done

    ########################################
    # Development plugins
    ########################################

    echo "" >> "$OUTPUT"
    echo "## Development Plugins" >> "$OUTPUT"

    find "$MOODLE_PATH" -name ".kaduvelasco" \
        | while read FILE; do

            PLUGIN_PATH=$(dirname "$FILE")
            echo "- $PLUGIN_PATH" >> "$OUTPUT"

        done

    ########################################
    # Plugins with AI context
    ########################################

    echo "" >> "$OUTPUT"
    echo "## Plugins With AI Context" >> "$OUTPUT"

    find "$MOODLE_PATH" -name "PLUGIN_AI_CONTEXT.md" \
        | while read FILE; do

            PLUGIN_PATH=$(dirname "$FILE")
            echo "- $PLUGIN_PATH" >> "$OUTPUT"

        done

    ########################################
    # Workspace structure
    ########################################

    echo "" >> "$OUTPUT"
    echo "## Workspace Structure" >> "$OUTPUT"

    for DIR in admin auth blocks course enrol grade local mod report theme tool; do

        if [ -d "$MOODLE_PATH/$DIR" ]; then
            echo "- $DIR/" >> "$OUTPUT"
        fi

    done

}
