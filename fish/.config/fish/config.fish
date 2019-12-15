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
source $HOME/.config/fish/aliases.fish
source $HOME/.config/fish/mpv.fish

# Language specific additions and paths
if test -e $HOME/.config/fish/go.fish
	source $HOME/.config/fish/go.fish
end

# Base16 Shell
if status --is-interactive; and test -e $HOME/.config/base16-shell/scripts/base16-monokai.sh
  eval sh $HOME/.config/base16-shell/scripts/base16-gruvbox-dark-hard.sh
end

### Color 'less' output
set -gx LESS_TERMCAP_mb \e'[01;31m'
set -gx LESS_TERMCAP_md \e'[01;31m'
set -gx LESS_TERMCAP_me \e'[0m'
set -gx LESS_TERMCAP_se \e'[0m'
set -gx LESS_TERMCAP_so \e'[01;44;33m'
set -gx LESS_TERMCAP_ue \e'[0m'
set -gx LESS_TERMCAP_us \e'[01;32m'

# set -gx fish_user_paths ~/anaconda3/bin $fish_user_paths
# private config not under public source control
if test -e $HOME/.config/fish/private.fish
	source $HOME/.config/fish/private.fish
end

if command --search --quiet "starship"
	eval (starship init fish)
end

if test -e $HOME/.dircolors
	eval (gdircolors --c-shell $HOME/.dircolors)
end

if test -e /usr/local/opt/llvm/bin
	set -g fish_user_paths "/usr/local/opt/llvm/bin" $fish_user_paths
end
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
