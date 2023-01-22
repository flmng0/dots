#!/usr/bin/env fish

function _json_list
    set -l quoted (printf '"%s"\n' $argv | string join ',')

    echo "[$quoted]"
end

function subscribe_focused
    echo (bspc query -D --desktop)

    bspc subscribe desktop_focus | while read -l _ _ desktop
        echo $desktop
    end
end

function _get_desktops
    set -l initial (bspc query -D --monitor default)
    echo (_json_list $initial)
end

function subscribe_desktops
    echo (_get_desktops)

    bspc subscribe desktop | while read -l event
        set -l type (string split ' ' $event)[1]
        if test $type != "desktop_focus"
            echo (_get_desktops)
        end
    end
end

switch $argv[1]
    case focused
        subscribe_focused
    case desktops
        subscribe_desktops
    case '*'
        exit 1
end
