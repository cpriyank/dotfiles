# Keychain opens ssh sockets at $HOSTNAME-fish
set -gx HOSTNAME (hostname)
if status --is-interactive;
    keychain --nogui --clear ~/.ssh/github ~/.ssh/msft
    [ -e $HOME/.keychain/$HOSTNAME-fish ]; and source $HOME/.keychain/$HOSTNAME-fish
end