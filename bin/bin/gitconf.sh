#!/usr/bin/env bash
# configure git, adapted from to https://github.com/iamcco/dotfiles/blob/master/dotfiles/bin/gitconf
# Takes one argument with value 'g' or 'w'

if [[ ! -d "$PWD/.git" ]]
then
    echo 'this is not an git project'
    exit 1
fi

base64decode="base64 -d -"

if [[ "$(uname)" = 'Darwin' ]]; then
    base64decode="base64 -D -"
fi

USER_NAME=$1

# Encode your names and email using base64 first. Like `echo "Jon Snow" | base64`
GEmail=$(echo "NTkwMzYwNCtjcHJpeWFua0B1c2Vycy5ub3JlcGx5LmdpdGh1Yi5jb20K" | $base64decode)
GName=$(echo "UHJpeWFuawo=" | $base64decode)

WEmail=$(echo "cHJpY2hhdWRAbWljcm9zb2Z0LmNvbQo=" | $base64decode)
WName=$(echo "UHJpeWFuawo=" | $base64decode)

git_config_list() {
    git config --list | grep user
}

if [ -n "$USER_NAME" ]
then
    if [ "$USER_NAME" == "g" ]
    then
        git config user.name $GName
        git config user.email $GEmail
        git_config_list
    elif [ "$USER_NAME" == "w" ]
    then
        git config user.name $WName
        git config user.email $WEmail
        git_config_list
    else
        echo "You must supply g or w as an argument"
    fi
else
    echo "You must supply g or w as an argument"
fi