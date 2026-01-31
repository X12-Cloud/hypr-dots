function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
end

starship init fish | source
if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
end

zoxide init fish | source

alias pacman 'sudo pacman'
alias sleep 'systemctl suspend'
alias ls 'eza --icons'
alias clear "printf '\033[2J\033[3J\033[1;1H'"
alias qs 'quickshell'
alias neofetch 'fastfetch'

# function fish_prompt
#   set_color cyan; echo (pwd)
#   set_color green; echo '> '
# end

# Created by `pipx` on 2025-07-19 08:14:58
set PATH $PATH /home/mohamed/.local/bin

# Custom aliases
# Fish source
function source-shell
    source ~/.config/fish/config.fish
end

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

# Nytro
function nytro
    "/run/media/mohamed/Mohamed/Mohameds place/X.co/Nytrogen - Compiler/Nytro-0.1/run.sh" $argv
end

fastfetch -c minimal
# echo 'Supernova mode ON'

# Add cargo bin to PATH for anyrun
# fish_add_path /home/mohamed/.cargo/bin

# function theme
#     /home/mohamed/.config/fish/theme-switcher $argv
# end
