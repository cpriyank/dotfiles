#/bin/zsh -f
# Convert all the files in current directory and subdirectories in m4a
command -v fdkaac parallel >/dev/null 2>&1 || { echo >&2 "fdkaac and parallel\
 required but they are not installed.  Aborting."; exit 1; }
find ./* -name "*.flac" -print | parallel -u 'ffmpeg -i {} -f caf - | fdkaac -b 256 - -o {}.m4a'
rename .flac.m4a .m4a ./*.m4a
