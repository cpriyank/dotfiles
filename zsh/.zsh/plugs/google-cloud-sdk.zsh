# The next line updates PATH for the Google Cloud SDK.
if [[ -f '/home/prichaud/Downloads/google-cloud-sdk/path.zsh.inc' ]]; then . '/home/prichaud/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [[ -f '/home/prichaud/Downloads/google-cloud-sdk/completion.zsh.inc' ]]; then . '/home/prichaud/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
if command -v colorls 2>&1 >/dev/null && command -v gem 2>&1 >/dev/null; then
  source $(dirname $(gem which colorls))/tab_complete.sh
  # override some of existing aliases with colorls
  source $HOME/.zsh/aliases/colorls.zsh
fi

source ~/miniconda3/bin/activate

# export DOTNET_ROOT=/opt/dotnet
# export MSBuildSDKsPath=$DOTNET_ROOT/sdk/$(${DOTNET_ROOT}/dotnet --version)/Sdks
# export PATH=${PATH}:${DOTNET_ROOT}
