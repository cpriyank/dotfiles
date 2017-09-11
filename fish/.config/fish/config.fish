# THEME PURE #
set fish_function_path /Users/pika/.config/fish/functions/theme-pure $fish_function_path
source ~/.config/fish/aliases.fish
source ~/.config/fish/functions/cdf.fish
# Base16 Shell
if status --is-interactive
    eval sh $HOME/.config/fish/base16-monokai-dark.sh
end
