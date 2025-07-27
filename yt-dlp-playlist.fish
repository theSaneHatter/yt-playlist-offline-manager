#!/bin/env fish


set album $argv[1]

echo downloading $album to $(pwd)
yt-dlp --extract-audio --audio-format mp3 --output "%(playlist_index)s-%(title)s.%(ext)s" --embed-thumbnail $album
for file in  *
    mv -- "$file" (string replace -a ' ' '-' -- "$file")
    end

echo 'change the language?
for file in *
      echo 'renaming' $file
      mv $file $(trans -brief $file)
'
