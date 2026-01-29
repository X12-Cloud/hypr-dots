#!/usr/bin/env bash

# Define the directory where the applets are located
APPLET_DIR="$HOME/.config/rofi/applets/bin"

# Function to display usage and applet descriptions
usage() {
    echo "Usage: $0 [OPTION]"
    echo "Run various Rofi applets."
    echo ""
    echo "Options:"
    echo "  --apps          - Launch a Rofi menu for favorite applications."
    echo "  --appasroot     - Launch a Rofi menu to run applications as root (use with caution)."
    echo "  --battery       - Launch a Rofi menu to display battery status."
    echo "  --brightness    - Launch a Rofi menu to control screen brightness."
    echo "  --mpd           - Launch a Rofi menu to control the Music Player Daemon (MPD)."
    echo "  --powermenu     - Launch a Rofi menu for system power actions (shutdown, reboot, lock)."
    echo "  --quicklinks    - Launch a Rofi menu for quick web links."
    echo "  --screenshot    - Launch a Rofi menu for taking screenshots."
    echo "  --volume        - Launch a Rofi menu to control system volume."
    echo "  --help          - Display this help message."
    echo ""
    echo "Example: $0 --powermenu"
}

# Check for an argument
if [ -z "$1" ]; then
    usage
    exit 1
fi

# Parse the argument
case "$1" in
    --apps)
        bash "$APPLET_DIR/apps.sh"
        ;;
    --appasroot)
        bash "$APPLET_DIR/appasroot.sh"
        ;;
    --battery)
        bash "$APPLET_DIR/battery.sh"
        ;;
    --brightness)
        bash "$APPLET_DIR/brightness.sh"
        ;;
    --mpd)
        bash "$APPLET_DIR/mpd.sh"
        ;;
    --powermenu)
        bash "$APPLET_DIR/powermenu.sh"
        ;;
    --quicklinks)
        bash "$APPLET_DIR/quicklinks.sh"
        ;;
    --screenshot)
        bash "$APPLET_DIR/screenshot.sh"
        ;;
    --volume)
        bash "$APPLET_DIR/volume.sh"
        ;;
    --help)
        usage
        ;;
    *)
        echo "Error: Invalid option '$1'."
        echo ""
        usage
        exit 1
        ;;
esac