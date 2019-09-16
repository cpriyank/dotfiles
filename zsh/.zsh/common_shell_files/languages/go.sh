# TODO: do it once only
if [[ ! -d $HOME/z/go ]]
then
    mkdir -p "$HOME/z/go"
fi

export GOPATH="$HOME/z/go"
appendToPath "$GOPATH/bin"
