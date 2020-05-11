#!/bin/bash

# Create a new directory and enter it
function md() {
	mkdir -p "$@" && cd "$@"
}


# find shorthand
function f() {
	find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

function pullall() {
	git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
	git fetch --all
	git pull --all
}

alias fetchall="pullall"