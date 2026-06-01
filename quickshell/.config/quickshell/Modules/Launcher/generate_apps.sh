#!/usr/bin/env bash

OUTPUT_FILE="$HOME/.config/quickshell/apps.json"
mkdir -p "$(dirname "$OUTPUT_FILE")"

echo "[" > "$OUTPUT_FILE"

first=true
# Scan both system and local user desktop entries
for file in /usr/share/applications/*.desktop "$HOME/.local/share/applications/"*.desktop; do
    [ -e "$file" ] || continue

    # Parse key data, ignoring lines that don't match exactly
    name=$(grep -m 1 "^Name=" "$file" | cut -d'=' -f2-)
    exec_cmd=$(grep -m 1 "^Exec=" "$file" | cut -d'=' -f2- | sed 's/ %.*//g')
    icon=$(grep -m 1 "^Icon=" "$file" | cut -d'=' -f2-)
    nodisplay=$(grep -m 1 "^NoDisplay=" "$file" | cut -d'=' -f2-)

    # Skip entries explicitly hidden from application menus
    if [ "$nodisplay" = "true" ] || [ -z "$name" ] || [ -z "$exec_cmd" ]; then
        continue
    fi

    # Fallback to a generic app icon if none specified
    if [ -z "$icon" ]; then
        icon="application-x-executable"
    fi

    # Escape quotes cleanly for valid JSON parsing
    name=$(echo "$name" | sed 's/"/\\"/g')
    exec_cmd=$(echo "$exec_cmd" | sed 's/"/\\"/g')

    if [ "$first" = true ]; then
        first=false
    else
        echo "," >> "$OUTPUT_FILE"
    fi

    echo "  { \"name\": \"$name\", \"exec\": \"$exec_cmd\", \"icon\": \"$icon\" }" >> "$OUTPUT_FILE"
done

echo "]" >> "$OUTPUT_FILE"
