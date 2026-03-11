#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$BASE_DIR/lib/utils.sh"

########################################
# API INDEX
########################################

generate_api_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_API_INDEX.md"

    echo "Gerando MOODLE_API_INDEX.md..."

    write_template "$BASE_DIR/templates/MOODLE_API_INDEX.md.tpl" "$OUTPUT"

    find "$MOODLE_PATH/lib" -name "*.php" 2>/dev/null \
        | while IFS= read -r FILE; do
            grep -oP 'function\s+[a-zA-Z0-9_]+' "$FILE" \
                | sed 's/function //'
        done | sort -u | while IFS= read -r FUNC; do
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

    write_template "$BASE_DIR/templates/MOODLE_EVENTS_INDEX.md.tpl" "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -path "*/db/events.php" -print \
        | while IFS= read -r FILE; do

        grep -oP "'eventname'\s*=>\s*'[^']+'" "$FILE" \
            | sed "s/'eventname' => '//" \
            | sed "s/'//"

    done | sort -u | while IFS= read -r EVENT; do
        echo "- $EVENT" >> "$OUTPUT"
    done
}

########################################
# TASKS INDEX
########################################

generate_tasks_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_TASKS_INDEX.md"

    echo "Gerando MOODLE_TASKS_INDEX.md..."

    write_template "$BASE_DIR/templates/MOODLE_TASKS_INDEX.md.tpl" "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -path "*/db/tasks.php" -print \
        | while IFS= read -r FILE; do

        grep -oP "'classname'\s*=>\s*'[^']+'" "$FILE" \
            | sed "s/'classname' => '//" \
            | sed "s/'//"

    done | sort -u | while IFS= read -r TASK; do
        echo "- $TASK" >> "$OUTPUT"
    done
}

########################################
# SERVICES INDEX
########################################

generate_services_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_SERVICES_INDEX.md"

    echo "Gerando MOODLE_SERVICES_INDEX.md..."

    write_template "$BASE_DIR/templates/MOODLE_SERVICES_INDEX.md.tpl" "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -path "*/db/services.php" -print \
        | while IFS= read -r FILE; do

        grep -oP "'methodname'\s*=>\s*'[^']+'" "$FILE" \
            | sed "s/'methodname' => '//" \
            | sed "s/'//"

    done | sort -u | while IFS= read -r SERVICE; do
        echo "- $SERVICE" >> "$OUTPUT"
    done
}

########################################
# DATABASE TABLES INDEX
########################################

generate_db_tables_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_DB_TABLES_INDEX.md"

    echo "Gerando MOODLE_DB_TABLES_INDEX.md..."

    write_template "$BASE_DIR/templates/MOODLE_DB_TABLES_INDEX.md.tpl" "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -path "*/db/install.xml" -print \
        | while IFS= read -r FILE; do

        grep -oP '<TABLE NAME="[^"]+"' "$FILE" \
            | sed 's/<TABLE NAME="//' \
            | sed 's/"//'

    done | sort -u | while IFS= read -r TABLE; do
        echo "- $TABLE" >> "$OUTPUT"
    done
}

########################################
# CLASSES INDEX
########################################

generate_classes_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_CLASSES_INDEX.md"

    echo "Gerando MOODLE_CLASSES_INDEX.md..."

    write_template "$BASE_DIR/templates/MOODLE_CLASSES_INDEX.md.tpl" "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -name "*.php" -print \
        | while IFS= read -r FILE; do

        NAMESPACE=$(grep -oP '^namespace\s+[a-zA-Z0-9_\\]+' "$FILE" \
            | head -1 | sed 's/namespace //')

        grep -oP 'class\s+[a-zA-Z0-9_]+' "$FILE" \
            | sed 's/class //' \
            | while IFS= read -r CLASS; do

                if [ -n "$NAMESPACE" ]; then
                    echo "$NAMESPACE\\$CLASS"
                else
                    echo "$CLASS"
                fi

            done

    done | sort -u | while IFS= read -r CLASS; do
        echo "- $CLASS" >> "$OUTPUT"
    done
}

########################################
# CALLBACKS INDEX
########################################

generate_callbacks_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_CALLBACKS_INDEX.md"

    echo "Gerando MOODLE_CALLBACKS_INDEX.md..."

    write_template "$BASE_DIR/templates/MOODLE_CALLBACKS_INDEX.md.tpl" "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -name "*.php" -print \
        | while IFS= read -r FILE; do

        grep -oP 'function\s+(mod|local|block|tool|auth|report|theme|qtype|atto|editor|filter|availability|format|assignsubmission|assignfeedback)_[a-zA-Z0-9_]+' "$FILE" \
            | sed 's/function //'

    done | sort -u | while IFS= read -r CALLBACK; do
        echo "- $CALLBACK" >> "$OUTPUT"
    done
}

########################################
# PLUGIN TYPES INDEX
########################################

generate_plugin_types_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_PLUGIN_TYPES.md"

    echo "Gerando MOODLE_PLUGIN_TYPES.md..."

    write_template "$BASE_DIR/templates/MOODLE_PLUGIN_TYPES.md.tpl" "$OUTPUT"

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
            echo "- $TYPE ($DIR/)"
        fi

    done | sort >> "$OUTPUT"
}

########################################
# SUBSYSTEMS INDEX
########################################

generate_subsystems_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_SUBSYSTEMS_INDEX.md"

    echo "Gerando MOODLE_SUBSYSTEMS_INDEX.md..."

    write_template "$BASE_DIR/templates/MOODLE_SUBSYSTEMS_INDEX.md.tpl" "$OUTPUT"

    {
        find "$MOODLE_PATH/lib/classes" -name "*.php" 2>/dev/null \
            | while IFS= read -r FILE; do
                grep -oP '^namespace\s+core_[a-zA-Z0-9_]+' "$FILE" \
                    | sed 's/namespace //'
            done

        CORE_DIRS=(user course group enrol grade files message calendar access)

        for DIR in "${CORE_DIRS[@]}"; do
            if [ -d "$MOODLE_PATH/$DIR" ]; then
                echo "core_${DIR}"
            fi
        done

        LIB_APIS=(filelib weblib accesslib completionlib gradelib)

        for API in "${LIB_APIS[@]}"; do
            if [ -f "$MOODLE_PATH/lib/$API.php" ]; then
                echo "core_${API%lib}"
            fi
        done

    } | sort -u | while IFS= read -r SUB; do
        echo "- $SUB" >> "$OUTPUT"
    done
}

########################################
# CAPABILITIES INDEX
########################################

generate_capabilities_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_CAPABILITIES_INDEX.md"

    echo "Gerando MOODLE_CAPABILITIES_INDEX.md..."

    write_template "$BASE_DIR/templates/MOODLE_CAPABILITIES_INDEX.md.tpl" "$OUTPUT"

    find "$MOODLE_PATH" \
        -path "*/vendor/*" -prune -o \
        -path "*/db/access.php" -print \
        | while IFS= read -r FILE; do

        grep -oP "'[a-zA-Z0-9_/]+:[a-zA-Z0-9_]+'" "$FILE" \
            | tr -d "'"

    done | sort -u | while IFS= read -r CAP; do
        echo "- $CAP" >> "$OUTPUT"
    done
}

########################################
# PLUGIN INDEX
########################################

generate_plugin_index() {

    local MOODLE_PATH="$1"
    local OUTPUT="$MOODLE_PATH/MOODLE_PLUGIN_INDEX.md"

    echo "Gerando MOODLE_PLUGIN_INDEX.md..."

    write_template "$BASE_DIR/templates/MOODLE_PLUGIN_INDEX.md.tpl" "$OUTPUT"

    find "$MOODLE_PATH" -mindepth 2 -maxdepth 2 -type f -name "version.php" \
        | while IFS= read -r FILE; do

        PLUGIN_DIR=$(dirname "$FILE")
        PLUGIN_NAME=$(basename "$PLUGIN_DIR")
        PLUGIN_TYPE=$(basename "$(dirname "$PLUGIN_DIR"))

        COMPONENT="${PLUGIN_TYPE}_${PLUGIN_NAME}"
        REL_PATH="${PLUGIN_TYPE}/${PLUGIN_NAME}"

        echo "| $COMPONENT | $PLUGIN_TYPE | $PLUGIN_NAME | $REL_PATH |" >> "$OUTPUT"

    done
}