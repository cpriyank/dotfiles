# The next line updates PATH for the Google Cloud SDK.
gcloud_sdk_dir="${HOME}/Downloads/google-cloud-sdk"
if [[ -r "${gcloud_sdk_dir}/path.zsh.inc" ]]; then . "${gcloud_sdk_dir}/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [[ -r "${gcloud_sdk_dir}/completion.zsh.inc" ]]; then . "${gcloud_sdk_dir}/completion.zsh.inc"; fi
unset gcloud_sdk_dir
