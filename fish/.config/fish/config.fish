###############################################################################
## Colors {{{
###############################################################################
### Base16 Shell colors
# if status --is-interactive; and test -e $HOME/.config/base16-shell/scripts/base16-monokai.sh
  # eval sh $HOME/.config/base16-shell/scripts/base16-monokai.sh
# end

### Color 'less' output
set -gx LESS_TERMCAP_mb \e'[01;31m'
set -gx LESS_TERMCAP_md \e'[01;31m'
set -gx LESS_TERMCAP_me \e'[0m'
set -gx LESS_TERMCAP_se \e'[0m'
set -gx LESS_TERMCAP_so \e'[01;44;33m'
set -gx LESS_TERMCAP_ue \e'[0m'
set -gx LESS_TERMCAP_us \e'[01;32m'

### color ls output. This is replaced by built-in colors in lsd
# if command --search --quiet gdircolors ;and test -e $HOME/.dircolors
# 	eval (gdircolors --c-shell $HOME/.dircolors)
# end

# if command --search --quiet dircolors ;and test -e $HOME/.dircolors
# 	eval (dircolors --c-shell $HOME/.dircolors)
# end
#}}}

if command --search --quiet "zoxide"
  zoxide init fish | source
end
### Some handy aliases
if test -e $HOME/.config/fish/aliases.fish
	source $HOME/.config/fish/aliases.fish
end

# Other custom paths
for custom_path in $HOME/.config/fish/paths/*.fish
      source $custom_path
end

# private config not under public source control
if test -e $HOME/.config/fish/private.fish
	source $HOME/.config/fish/private.fish
end

###############################################################################
### Environment variables {{{
###############################################################################
# Set EDITOR. Hope I won't have to resort to pico
if command --search --quiet "nvim"
	set -gx EDITOR nvim
else if command --search --quiet "vim"
	set -gx EDITOR vim
else
	set -gx EDITOR nano
end
#}}}

# Start X at login
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx -- -keeptty
    end
end

# Track the number of shell sessions
set -U fish_gc_count (math (set -q fish_gc_count; echo $fish_gc_count) + 1)

# Run garbage collection every 1000 sessions
if test $fish_gc_count -ge 1000
    echo "Running Nix garbage collection..."
    /run/current-system/sw/bin/nix-collect-garbage -d
    set -U fish_gc_count 0  # Reset the counter
end
