### Navigation
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end


### File size
function fs
	stat -f "%z bytes" $argv
end

function v
	eval $EDITOR $argv
end

function l
	la $argv
end

function m
	tmux
end

function a
	tmux attach
end

# Open vim in readonly mode
function vr
	v -R $argv
end

function scp
	command scp -p $argv
end

function wget
	command wget -c $argv
end

function pong
	ping -c 3 www.google.com
end

function xrr
	xrdb ~/.Xresources
end

function t
	if test -n $argv 
		tree -C $argv 
	else 
		tree -C .
	end
end

# cat files with syntax highlighting
function c
	pygmentize -O style=monokai -f console256 -g $argv
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
	trash $argv
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

# just play audio from a video file or url
function p
	mpv --no-video $argv
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

# pretty print the path
function ppath
  echo $PATH | tr -s " " "\n"
end

# case insensitive rg
function rgi
  rg -i $argv
end

# case insensitive rg with $EDITOR
function rgil
	rg -l -i $argv | xargs $EDITOR
end

function k
  kak $argv
end
