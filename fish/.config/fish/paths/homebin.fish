if test -d $HOME/bin
    set -gx fish_user_paths $fish_user_paths $HOME/bin
end
if test -d $HOME/.config/emacs/bin
    set -gx fish_user_paths $fish_user_paths $HOME/.config/emacs/bin
end