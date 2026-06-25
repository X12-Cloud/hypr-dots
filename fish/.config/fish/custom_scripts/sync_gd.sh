#!/bin/bash

# Configuration Paths
WIN_PATH="/run/media/x12/C4FED68CFED675E0/Users/Administrator/AppData/Local/GeometryDash/"
LINUX_PATH="$HOME/.local/share/Steam/steamapps/compatdata/322170/pfx/drive_c/users/steamuser/AppData/Local/GeometryDash/"

# Check if the Windows mount path exists
if [ ! -d "$WIN_PATH" ]; then
    echo "❌ Error: Windows directory not found! Is the drive mounted at /run/media/x12/C4FED68CFED675E0?"
    exit 1
fi

# Ensure Linux destination directory exists
mkdir -p "$LINUX_PATH"

# Run sync based on flags
if [[ "$1" == "--reverse" ]]; then
    echo "🔄 Syncing from Linux (Proton) ➡️ Windows (NTFS)..."
    # -r: recursive, -t: preserve times, -v: verbose, --modify-window: bypass NTFS time precision discrepancies
    rsync -rtv --progress --modify-window=1 "$LINUX_PATH" "$WIN_PATH"
else
    echo "🔄 Syncing from Windows (NTFS) ➡️ Linux (Proton)..."
    rsync -rtv --progress --modify-window=1 "$WIN_PATH" "$LINUX_PATH"
fi

echo "✅ Synchronization complete!"
