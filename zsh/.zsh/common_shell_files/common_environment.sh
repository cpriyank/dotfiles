if hash nvim 2>/dev/null
then
    export EDITOR="nvim"
elif hash kak 2>/dev/null
then
    export EDITOR="kak"
elif hash vim 2>/dev/null
then
    export EDITOR="vim"
else
    export EDITOR="nano"
fi

# https://wiki.archlinux.org/index.php/locale
export LC_COLLATE=C

# always use color, even when piping (to awk, grep, etc)
export CLICOLOR_FORCE=1
