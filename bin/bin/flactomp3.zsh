#!/usr/bin/zsh -f
# Convert flac files in a given directory to mp3 using ffmpeg, GNU parallel,
# and moreutils
parallel-moreutils -i -j$(nproc) ffmpeg -i {} -qscale:a 0 {}.mp3 -- ./*.flac
rename .flac.mp3 .mp3 ./*.mp3
