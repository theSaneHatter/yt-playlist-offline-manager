#!/bin/env fish
#started 7-21-25; this program is to download new songs from a yt playlist that has been updated
#it grabs the names in the playlist, checks if those songs r in current dir
#it currently still needs to do the downloading part -_-
#progress: need to make it so that it still works if songs dont have "-" in them
set album $argv[1]

echo updateing $album in $(pwd)
#! uncomment this
 echo '' > ._raw-playlist-names.txt
 echo '' > ._playlist-names.txt
 echo '' > ._raw-local-names.txt
 echo '' > ._local-names.txt
 echo '' > ._needed-songs.txt
 yt-dlp --quiet --flat-playlist --print "%(playlist_index)s-%(title)s" $album > ._raw-playlist-names.txt
 for line in $(cat ._raw-playlist-names.txt)
        echo removing spaces for $line
        echo $(string replace -a ' ' '-' -- "$line") >> ._playlist-names.txt
    end
#remove empty line
sed -i '1d' ._playlist-names.txt

#make sure all songs alr downloaded are valid
for file in (ls | grep -E '\.mp3$|\.ogg$|\.flac$|\.wav$|\.aac$|\.m4a$|\.opus$|\.wma$|\.alac$|\.aiff$')
    set song_name (string join '' (string split - (basename (string replace -r '\.[^.]*$' '' $file)))[2..])
    if test -z "$song_name"
       set song_name (basename (string replace -r '\.[^.]*$' '' $file))
       echo "Worning: $song_name does not contain index or anything... its name is: $file"
    end

    if test -n "$song_name" && grep -q "$song_name" ._raw-playlist-names.txt
       echo found (string join '' (string split - $file)[2..]) 'in album' at index (string join '' (string split - $file)[1])
       echo file is called $file song name: "$song_name"
       echo "$file is in dir: "
       echo ...dir: $(grep "$song_name" ._playlist-names.txt)
       echo $song_name >> ._local-names.txt
       echo $file >> ._raw-local-names.txt

    else
         echo "did not find >$song_name<, with filename >$file< in songs list, it appears to be an invalid song..."
         read --prompt "echo 'delete >$song_name<? (y/n)'" -l ans
         echo answer: $ans

         while true
               if contains $ans = 'exit'
                  exit
               end
               if contains $ans 'y' 'n'
                  break
                  echo debug: ans contains y or n
               end
               echo 'answer must be y or n'
               read --prompt "echo 'delete >$song_name<? (y/n)'" -l ans
               echo answer: $ans
        end
        if test "$ans" = 'y'
           echo deleteing $file
           rm $file
        end

    end
end

sed -i '1d' ._local-names.txt
sed -i '1d' ._raw-local-names.txt

#make file of differances
for song in (cat ._playlist-names.txt)
    set name (string join '' (string split - $song)[2..])
    if not grep $name ._local-names.txt
       echo $song >> ._needed-songs.txt
       echo "found $song as needed for downloading"
    end
end
sed -i '1d' ._needed-songs.txt
echo 'progress: made file of needed songs'

#download songs needed
for song in (cat ._needed-songs.txt)
    set index (string split - $song)[1]
    echo debug: needed index: $index
    echo "downloading $name"
    yt-dlp --playlist-items $index --embed-metadata --extract-audio --audio-format mp3 --output "%(playlist_index)s-%(title)s.%(ext)s" --embed-thumbnail $album
end



#exparamental !
#List songs with index and title
# remove charictor
#echo (string join '' ( string split i abicdisad)[2..])

#yt-dlp --quiet --no-progress --flat-playlist --print "%(playlist_index)s - %(title)s" $playlist_url | while read -l line
    # Check if the line contains your filter word (case-insensitive)
#   if string match -qi "title" $line
#       # Extract the index (assumes index is first word before space or dash)
#       set index (echo $line | awk '{print $1}')
#       # Download just that video by index
#       yt-dlp --playlist-items $index -o "%(playlist_index)02d-%(title)s.%(ext)s" $playlist_url
#   end
#end

    

# yt-dlp --embed-metadata --extract-audio --audio-format mp3 --output "%(playlist_index)s-%(title)s.%(ext)s" --embed-thumbnail $album

#uncomment later
for file in (ls | grep -E '\.mp3$|\.ogg$|\.flac$|\.wav$|\.aac$|\.m4a$|\.opus$|\.wma$|\.alac$|\.aiff$')
   set modded (string replace -a ' ' '-' -- "$file")
   if test $file = $modded
   else
       echo note: renaming $file to $modded
       mv $file $modded
    end
end

#uncomment later
#rm._raw-playlist-names.txt
#rm ._playlist-names.txt
#rm ._raw-local-names.txt
#rm ._local-names.txt
#rm ._needed-songs.txt
