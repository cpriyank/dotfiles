if test -e /usr/local/opt/llvm/bin
	set -gx fish_user_paths "/usr/local/opt/llvm/bin" $fish_user_paths
	set -gx fish_user_paths "/usr/local/sbin" $fish_user_paths
end
