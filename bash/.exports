if hash nvim 2>/dev/null
then
    export EDITOR="nvim"
elif hash vim 2>/dev/null
then
    export EDITOR="vim"
else
    export EDITOR="nano"
fi

# https://wiki.archlinux.org/index.php/locale
export LC_COLLATE=C

# todo: don't do this by default
if [[ ! -d $HOME/z/go ]]
then
    mkdir -p $HOME/z/go
fi

export GOPATH=$HOME/z/go
PATH=$PATH:$GOPATH

PATH=$PATH:$HOME/.gem/ruby/2.6.0/bin
