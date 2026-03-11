#!/usr/bin/env bash

# Diretório base do projeto moodle-ai
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

########################################
# API INDEX
########################################

generate_api_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_API_INDEX.md"

    echo "Gerando MOODLE_API_INDEX.md..."

    cat "$BASE_DIR/templates/MOODLE_API_INDEX.md.tpl" > "$OUTPUT"

    echo "" >> "$OUTPUT"

    grep -RhoP 'function\s+[a-zA-Z0-9_]+' "$MOODLE_PATH/lib" \
        | sed 's/function //' \
        | sort -u \
        | while read FUNC; do
            echo "- $FUNC()" >> "$OUTPUT"
        done

}

########################################
# EVENTS INDEX
########################################

generate_events_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_EVENTS_INDEX.md"

    echo "Gerando MOODLE_EVENTS_INDEX.md..."

    cat "$BASE_DIR/templates/MOODLE_EVENTS_INDEX.md.tpl" > "$OUTPUT"

    echo "" >> "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -path "*/db/events.php" -print | while read FILE; do

        grep -oP "'eventname'\s*=>\s*'[^']+'" "$FILE" \
            | sed "s/'eventname' => '//" \
            | sed "s/'//" \
            | sort -u \
            | while read EVENT; do
                echo "- $EVENT" >> "$OUTPUT"
            done

    done

}

########################################
# TASKS INDEX
########################################

generate_tasks_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_TASKS_INDEX.md"

    echo "Gerando MOODLE_TASKS_INDEX.md..."

    cat "$BASE_DIR/templates/MOODLE_TASKS_INDEX.md.tpl" > "$OUTPUT"

    echo "" >> "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -path "*/db/tasks.php" -print | while read FILE; do

        grep -oP "'classname'\s*=>\s*'[^']+'" "$FILE" \
            | sed "s/'classname' => '//" \
            | sed "s/'//" \
            | sort -u \
            | while read TASK; do
                echo "- $TASK" >> "$OUTPUT"
            done

    done

}

########################################
# SERVICES INDEX
########################################

generate_services_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_SERVICES_INDEX.md"

    echo "Gerando MOODLE_SERVICES_INDEX.md..."

    cat "$BASE_DIR/templates/MOODLE_SERVICES_INDEX.md.tpl" > "$OUTPUT"

    echo "" >> "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -path "*/db/services.php" -print | while read FILE; do

        grep -oP "'methodname'\s*=>\s*'[^']+'" "$FILE" \
            | sed "s/'methodname' => '//" \
            | sed "s/'//" \
            | sort -u \
            | while read SERVICE; do
                echo "- $SERVICE" >> "$OUTPUT"
            done

    done

}

########################################
# DATABASE TABLES INDEX
########################################

generate_db_tables_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_DB_TABLES_INDEX.md"

    echo "Gerando MOODLE_DB_TABLES_INDEX.md..."

    cat "$BASE_DIR/templates/MOODLE_DB_TABLES_INDEX.md.tpl" > "$OUTPUT"

    echo "" >> "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -path "*/db/install.xml" -print | while read FILE; do

        grep -oP '<TABLE NAME="[^"]+"' "$FILE" \
            | sed 's/<TABLE NAME="//' \
            | sed 's/"//' \
            | sort -u \
            | while read TABLE; do
                echo "- $TABLE" >> "$OUTPUT"
            done

    done

}

########################################
# CLASSES INDEX
########################################

generate_classes_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_CLASSES_INDEX.md"

    echo "Gerando MOODLE_CLASSES_INDEX.md..."

    cat "$BASE_DIR/templates/MOODLE_CLASSES_INDEX.md.tpl" > "$OUTPUT"

    echo "" >> "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -name "*.php" -print | while read FILE; do

        NAMESPACE=$(grep -oP '^namespace\s+[a-zA-Z0-9_\\]+' "$FILE" | head -1 | sed 's/namespace //')

        grep -oP 'class\s+[a-zA-Z0-9_]+' "$FILE" \
            | sed 's/class //' \
            | while read CLASS; do

                if [ -n "$NAMESPACE" ]; then
                    echo "- $NAMESPACE\\$CLASS"
                else
                    echo "- $CLASS"
                fi

            done

    done | sort -u >> "$OUTPUT"

}

########################################
# CALLBACKS INDEX
########################################

generate_callbacks_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_CALLBACKS_INDEX.md"

    echo "Gerando MOODLE_CALLBACKS_INDEX.md..."

    cat "$BASE_DIR/templates/MOODLE_CALLBACKS_INDEX.md.tpl" > "$OUTPUT"

    echo "" >> "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -name "*.php" -print | while read FILE; do

        grep -oP 'function\s+(mod|local|block|tool|auth|report|theme|qtype|atto|editor|filter|availability|format|assignsubmission|assignfeedback)_[a-zA-Z0-9_]+' "$FILE" \
            | sed 's/function //' \
            | while read CALLBACK; do
                echo "- $CALLBACK"
            done

    done | sort -u >> "$OUTPUT"

}

########################################
# PLUGIN TYPES INDEX
########################################

generate_plugin_types_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_PLUGIN_TYPES.md"

    echo "Gerando MOODLE_PLUGIN_TYPES.md..."

    cat "$BASE_DIR/templates/MOODLE_PLUGIN_TYPES.md.tpl" > "$OUTPUT"

    echo "" >> "$OUTPUT"

    declare -A TYPES

    TYPES[mod]="mod"
    TYPES[block]="blocks"
    TYPES[local]="local"
    TYPES[tool]="admin/tool"
    TYPES[auth]="auth"
    TYPES[report]="report"
    TYPES[theme]="theme"
    TYPES[format]="course/format"
    TYPES[filter]="filter"
    TYPES[editor]="lib/editor"
    TYPES[atto]="lib/editor/atto/plugins"
    TYPES[qtype]="question/type"
    TYPES[availability]="availability/condition"
    TYPES[assignsubmission]="mod/assign/submission"
    TYPES[assignfeedback]="mod/assign/feedback"

    for TYPE in "${!TYPES[@]}"; do

        DIR="${TYPES[$TYPE]}"

        if [ -d "$MOODLE_PATH/$DIR" ]; then
            echo "- $TYPE ($DIR/)" >> "$OUTPUT"
        fi

    done | sort

}

########################################
# SUBSYSTEMS INDEX
########################################

generate_subsystems_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_SUBSYSTEMS_INDEX.md"

    echo "Gerando MOODLE_SUBSYSTEMS_INDEX.md..."

    cat "$BASE_DIR/templates/MOODLE_SUBSYSTEMS_INDEX.md.tpl" > "$OUTPUT"
    echo "" >> "$OUTPUT"

    # 1) Namespaces core_* em classes
    find "$MOODLE_PATH/lib/classes" -name "*.php" 2>/dev/null | while read FILE; do
        grep -oP '^namespace\s+core_[a-zA-Z0-9_]+' "$FILE" \
            | sed 's/namespace //' \
            | while read NS; do
                echo "- $NS (lib/classes)"
            done
    done

    # 2) Diretórios principais do core que funcionam como subsistemas
    CORE_DIRS=(
        user
        course
        group
        enrol
        grade
        files
        message
        calendar
        access
    )

    for DIR in "${CORE_DIRS[@]}"; do
        if [ -d "$MOODLE_PATH/$DIR" ]; then
            echo "- core_${DIR} ($DIR/)"
        fi
    done

    # 3) APIs importantes em lib/
    LIB_APIS=(
        filelib
        weblib
        accesslib
        completionlib
        gradelib
    )

    for API in "${LIB_APIS[@]}"; do
        if [ -f "$MOODLE_PATH/lib/$API.php" ]; then
            echo "- core_${API%lib} (lib/$API.php)"
        fi
    done

    # Remover duplicados
    sort -u >> "$OUTPUT"

}

########################################
# CAPABILITIES INDEX
########################################

generate_capabilities_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_CAPABILITIES_INDEX.md"

    echo "Gerando MOODLE_CAPABILITIES_INDEX.md..."

    cat "$BASE_DIR/templates/MOODLE_CAPABILITIES_INDEX.md.tpl" > "$OUTPUT"
    echo "" >> "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -path "*/db/access.php" -print | while read FILE; do

        grep -oP "'[a-zA-Z0-9_/]+:[a-zA-Z0-9_]+'" "$FILE" \
            | tr -d "'" \
            | while read CAP; do
                echo "- $CAP"
            done

    done | sort -u >> "$OUTPUT"

}

########################################
# DATABASE SCHEMA
########################################

generate_database_schema() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_DATABASE_SCHEMA.md"

    echo "Gerando MOODLE_DATABASE_SCHEMA.md..."

    cat "$BASE_DIR/templates/MOODLE_DATABASE_SCHEMA.md.tpl" > "$OUTPUT"
    echo "" >> "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -path "*/db/install.xml" -print | while read FILE; do

        TABLES=$(grep -oP '<TABLE NAME="[^"]+"' "$FILE" | sed 's/<TABLE NAME="//' | sed 's/"//')

        for TABLE in $TABLES; do

            echo "" >> "$OUTPUT"
            echo "### $TABLE" >> "$OUTPUT"
            echo "" >> "$OUTPUT"
            echo "| Field | Type |" >> "$OUTPUT"
            echo "|------|------|" >> "$OUTPUT"

            grep -A100 "<TABLE NAME=\"$TABLE\"" "$FILE" \
                | grep -oP '<FIELD NAME="[^"]+" TYPE="[^"]+"' \
                | while read FIELDLINE; do

                    FIELD=$(echo "$FIELDLINE" | grep -oP 'NAME="[^"]+"' | sed 's/NAME="//' | sed 's/"//')
                    TYPE=$(echo "$FIELDLINE" | grep -oP 'TYPE="[^"]+"' | sed 's/TYPE="//' | sed 's/"//')

                    echo "| $FIELD | $TYPE |" >> "$OUTPUT"

                done

        done

    done

}

########################################
# PLUGIN DEPENDENCIES
########################################

generate_plugin_dependencies_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_PLUGIN_DEPENDENCIES.md"

    echo "Gerando MOODLE_PLUGIN_DEPENDENCIES.md..."

    cat "$BASE_DIR/templates/MOODLE_PLUGIN_DEPENDENCIES.md.tpl" > "$OUTPUT"
    echo "" >> "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -name "version.php" -print | while read FILE; do

        PLUGIN_DIR=$(dirname "$FILE")
        PLUGIN_NAME=$(basename "$PLUGIN_DIR")

        echo "" >> "$OUTPUT"
        echo "### $PLUGIN_NAME" >> "$OUTPUT"

        # versão mínima Moodle
        REQUIRES=$(grep -oP "\$plugin->requires\s*=\s*\K[0-9]+" "$FILE")

        if [ -n "$REQUIRES" ]; then
            echo "- Moodle required: $REQUIRES" >> "$OUTPUT"
        fi

        # dependências
        if grep -q "\$plugin->dependencies" "$FILE"; then

            echo "- Dependencies:" >> "$OUTPUT"

            grep -A20 "\$plugin->dependencies" "$FILE" \
                | grep "=>" \
                | sed "s/[',]//g" \
                | while read LINE; do

                    DEP=$(echo "$LINE" | awk -F"=>" '{print $1}' | xargs)
                    VER=$(echo "$LINE" | awk -F"=>" '{print $2}' | xargs)

                    echo "  - $DEP => $VER" >> "$OUTPUT"

                done
        fi

    done

}
