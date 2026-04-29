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

# Nyproj
function nyproj
    "$HOME/.config/tmux/nyproj.sh"
end

# Geometry Dash
function gdplay
    "$HOME/.config/fish/functions/gd.sh"
end


# Old stuff
# function theme
#     $HOME/.config/fish/theme-switcher $argv
# end

# function fish_prompt
#   set_color cyan; echo (pwd)
#   set_color green; echo '> '
# end
