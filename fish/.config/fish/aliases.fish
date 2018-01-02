### Navigation
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end


### File size
function fs
	stat -f \"%z bytes\" $argv
end

function v
	$EDITOR $argv
end

function l
	la $argv
end

function m
	tmux -f ~/.tmux/config
end

function a
	tmux attach
end

# Open vim in readonly mode
function vr
	v -R $argv
end

function scp
	scp -p $argv
end

function wget
	wget -c $argv
end

function pong
	ping -c 3 www.google.com
end

function xrr
	xrdb ~/.Xresources
end

function tree
	tree -C $argv
end

# Make du readable
function da
	du -sch $argv
end

# Warn on overwrite
function mv
	command gmv --interactive --verbose $argv
end

function rm
	command grm --interactive --verbose $argv
end

function cp
	command gcp --interactive --verbose $argv
end

### Download video by URL from STDIN
function apo
	youtube-dl $argv
end

function asong
	youtube-dl -f 251 $argv
end

# Download videos from the list of URLs from a file
function apone
	youtube-dl -a $argv
end

### Redshift aliases. For saving eyes, seriously.
# Gandhinagar coordinates
function shantib
	redshift -o -l 23.22:72.68
end

# Seattle coordinates  
function shanti
	redshift -o -l 47.61:-122.33 -t 4500:2800
end

# Reset color
function ashanti
	redshift -x
end

### Recursively delete `.DS_Store` files
function cleanup
	find . -name '*.DS_Store' -type f -ls
end

### Git specific
function ga
	git add $argv
end

function gc
	git commit -v $argv
end

function gco
	git checkout $argv
end

function gsb
	git status -sb
end

function gst
	git status
end

function gd
	git diff $argv
end

function glola
	git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all
end

function gp
	git push $argv
end

function gpd
	git push --dry-run $argv
end

function grh
	git reset HEAD -- $argv
end