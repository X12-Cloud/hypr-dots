# Custom Stuff

# Source fish
function source-shell
    source ~/.config/fish/config.fish
end

# Git
function commit
    "$HOME/.config/scripts/git/commit.sh" $argv
end

# Rofi
function rofi
    "$HOME/.config/rofi/run.sh" $argv
end
