#!/usr/bin/zsh -f
# Check the entire filesystem for files modified since yesterday
print -l /**/*(*.m-1)
