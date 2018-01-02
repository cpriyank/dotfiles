if not test -d $HOME/z/go
    mkdir -p $HOME/z/go
end
set -gx GOPATH $HOME/z/go
set -gx fish_user_paths $GOPATH/bin $fish_user_paths