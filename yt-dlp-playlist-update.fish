#!/bin/env fish
#started 7-21-25; this program is to download new songs from a yt playlist that has been updated
#it grabs the names in the playlist, checks if those songs r in current dir
#it currently still needs to do the downloading part -_-
set album $argv[1]

echo updateing $album in $(pwd)
#! uncomment this
#echo '' > _temp.txt
#echo '' > _temp2.txt
#yt-dlp --quiet --flat-playlist --print "%(playlist_index)s-%(title)s" $album > _temp.txt
#for line in $(cat _temp.txt)
#       echo removing spaces for $line
#       echo $(string replace -a ' ' '-' -- "$line") >> _temp2.txt
#   end

#make sure all songs alr downloaded are valid
for file in (ls | grep -E '\.mp3$|\.ogg$|\.flac$|\.wav$|\.aac$|\.m4a$|\.opus$|\.wma$|\.alac$|\.aiff$')
    set song_name (string join '' (string split - (basename (string replace -r '\.[^.]*$' '' $file)))[2..])
    if grep -q "$song_name" _temp2.txt
       echo found (string join '' (string split - $file)[2..]) 'in album' at index (string join '' (string split - $file)[1])
       echo file is called $file
       echo "$file is in dir: "
       echo ...dir: $(grep "$song_name" _temp2.txt)
    else
         echo "did not find $song_name in songs list, it appears to be an invalid song..."
         read --prompt "echo 'remove $song_name? (y/n)'" -l ans
         echo ans
    end
end

#for file in *
#   if grep -q (basename (string replace -r '\.[^.]*$' '' $file)) _temp2.txt
#     echo found $file 'in album'

#     end

#   end



#exparamental !
#List songs with index and title
# remove charictor
echo (string join '' ( string split i abicdisad)[2..])

#yt-dlp --quiet --no-progress --flat-playlist --print "%(playlist_index)s - %(title)s" $playlist_url | while read -l line
    # Check if the line contains your filter word (case-insensitive)
#   if string match -qi "title" $line
#       # Extract the index (assumes index is first word before space or dash)
#       set index (echo $line | awk '{print $1}')
#       # Download just that video by index
#       yt-dlp --playlist-items $index -o "%(playlist_index)02d-%(title)s.%(ext)s" $playlist_url
#   end
#end

    

# yt-dlp --extract-audio --audio-format mp3 --output "%(playlist_index)s-%(title)s.%(ext)s" --embed-thumbnail $album

#uncomment later
# for file in  *
#    mv -- "$file" (string replace -a ' ' '-' -- "$file")
#   end
