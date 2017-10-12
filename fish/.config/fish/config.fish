source ~/.config/fish/aliases.fish
source ~/.config/fish/functions/cdf.fish


set -gx GOPATH ~/z/go
set -gx PATH /usr/local/sbin ~/z/go/bin /snap/bin $PATH
# Base16 Shell
# if status --is-interactive
#     eval sh $HOME/.config/fish/base16-monokai-dark.sh
# end

# THEME PURE #
set fish_function_path ~/.config/fish/functions/pure $fish_function_path

set pure_username_color $pure_color_blue
set pure_host_color $pure_color_blue
