function pullall
	git branch -r | grep -v '\->' | while read --list --local remote; git branch --track (string replace origin/ '' $remote) $remote; end
	git fetch --all
	git pull --all
end
