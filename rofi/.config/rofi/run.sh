#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x

# Function to display usage
usage() {
    echo "Usage: $0 <flag> [args...]"
    echo
    echo "Flags:"
    echo "  norm   <type> <style> <mode>   - Run the normal launcher (e.g., norm 1 1 drun)"
    echo "  power  <type> <style>          - Run the power menu (e.g., power 1 1)"
    echo "  applet <name> <type> <style>   - Run an applet (e.g., applet battery 1 1)"
    exit 1
}

# Check for arguments
if [ $# -eq 0 ]; then
    usage
fi

FLAG="$1"
shift

case "$FLAG" in
    norm)
        TYPE="$1"
        STYLE="$2"
        MODE="$3"
        if [ -z "$TYPE" ] || [ -z "$STYLE" ] || [ -z "$MODE" ]; then
            echo "Error: Missing arguments for 'norm' flag."
            usage
        fi
        dir="$HOME/.config/rofi/launchers/type-${TYPE}"
        theme="style-${STYLE}"
        rofi -show "$MODE" -theme "${dir}/${theme}.rasi"
        ;;

    power)
        TYPE="$1"
        STYLE="$2"
        if [ -z "$TYPE" ] || [ -z "$STYLE" ]; then
            echo "Error: Missing arguments for 'power' flag."
            usage
        fi
        dir="$HOME/.config/rofi/powermenu/type-${TYPE}"
        theme="style-${STYLE}"
        # The powermenu script needs to be modified to accept a theme path
        bash "${dir}/powermenu.sh" "${dir}/${theme}.rasi"
        ;;

    applet)
        APPLET_NAME="$1"
        TYPE="$2"
        STYLE="$3"
        if [ -z "$APPLET_NAME" ] || [ -z "$TYPE" ] || [ -z "$STYLE" ]; then
            echo "Error: Missing arguments for 'applet' flag."
            usage
        fi
        dir="$HOME/.config/rofi/applets/type-${TYPE}"
        theme="style-${STYLE}"
        # The applet script needs to be modified to accept a theme path
        bash "$HOME/.config/rofi/applets/bin/${APPLET_NAME}.sh" "${dir}/${theme}.rasi"
        ;;

    *)
        echo "Error: Invalid flag '$FLAG'."
        usage
        ;;
esac