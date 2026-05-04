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
alias s 'sudo'

alias openvault='sudo cryptsetup open ~/secrets.img my_vault && sudo mount /dev/mapper/my_vault ~/private_stuff'
alias closevault='sudo umount ~/private_stuff && sudo cryptsetup close my_vault'

# Created by `pipx` on 2025-07-19 08:14:58
set PATH $PATH /home/mohamed/.local/bin
# fish_add_path $HOME/.cargo/bin

fastfetch -c minimal

# Custom aliases
source (dirname (status filename))/aliases.fish
