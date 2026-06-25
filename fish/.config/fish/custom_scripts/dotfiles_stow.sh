#!/usr/bin/env bash

DOTFILES_DIR="${HOME}/dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "Error: $DOTFILES_DIR not found!"
    exit 1
fi

echo "Stowing applications to home directory..."

cd "$DOTFILES_DIR" || exit 1

for app in */; do
    app="${app%/}"

    # Skip specific non-config directories
    if [[ "$app" == "assets" || "$app" == "scripts" ]]; then
        continue
    fi

    echo "Stowing: $app"

    if [[ "$1" == "-f" ]]; then
        if [[ -d "$app/.config" ]]; then
            shopt -s dotglob
            for target in "$app"/.config/*; do
                if [[ -e "$target" ]]; then
                    basename=$(basename "$target")
                    TARGET_PATH="$HOME/.config/$basename"

                    if [[ -L "$TARGET_PATH" ]]; then
                        echo "  -> Removing existing symlink: $TARGET_PATH"
                        rm "$TARGET_PATH"
                    elif [[ -d "$TARGET_PATH" ]]; then
                        echo "  -> Removing physical directory: $TARGET_PATH"
                        rm -rf "$TARGET_PATH"
                    elif [[ -f "$TARGET_PATH" ]]; then
                        echo "  -> Removing physical file: $TARGET_PATH"
                        rm "$TARGET_PATH"
                    fi
                fi
            done
            shopt -u dotglob
        fi
    fi

    # Execute stow on the app module
    stow --adopt -t "$HOME" "$app"
done

echo "Stow synchronization complete!"
