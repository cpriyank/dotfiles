### Environment variables
# Set EDITOR. Hope I won't have to resort to pico
if command --search --quiet "nvim"
    set -gx EDITOR nvim
else if command --search --quiet "vim"
    set -gx EDITOR vim
else
    set -gx EDITOR nano
end

### Some handy aliases
source ~/.config/fish/aliases.fish

### Language specific additions and paths
source ~/.config/fish/go.fish

### Base16 Shell
if status --is-interactive
    eval sh $HOME/.config/base16-shell/scripts/base16-monokai.sh
end

### Pure prompt theme
set fish_function_path $fish_function_path $HOME/.config/fish/pure
