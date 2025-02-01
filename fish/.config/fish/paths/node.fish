set NPM_PACKAGES $HOME/.local/npm-packages

set -gx fish_user_paths $NPM_PACKAGES/bin $fish_user_paths
# set npm_config_prefix to avoid the need to use sudo when installing global packages
set -gx npm_config_prefix $NPM_PACKAGES
