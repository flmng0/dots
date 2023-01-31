#!/usr/bin/env fish

if not test -d "$PWD/assets"
    mkdir "$PWD/assets"
end

set -l format "\
{{artist}}
{{title}}
{{position}}
{{duration(position)}}
{{mpris:length}}
{{duration(mpris:length)}}"

function make_json
    set -l fields artist title position readablePosition length readableLength
    
    set -l fieldCount (count $fields)
    printf '{'
    for i in (seq 1 $fieldCount)
        printf "\"$fields[$i]\": \"$argv[$i]\""
        if test $i -lt $fieldCount
            printf ", "
        end
    end
    printf '}'
end

# echo (make_json "Fake Artist Name" "Fake Video Name Which is Also Very Very Long, Because Then I Can Test Formatting" "" "" "" "")

playerctl metadata --follow --format $format | while read -L -l artist title artUrl pos rPos len rLen
    if not playerctl position > /dev/null 2>&1
        set pos ""
        set rPos ""
    end

    if test -n $artUrl
        cp (string replace "file://" "" $artUrl) "$PWD/assets/musicThumbnail"
    end
        
    echo (make_json $artist $title $pos $rPos $len $rLen)
end
