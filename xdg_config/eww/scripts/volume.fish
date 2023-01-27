#!/usr/bin/env fish

function get_volume
    set -l volume (pactl -- get-sink-volume 0 | awk -F"/" '{print $2}' | string trim)
    set -l level (string sub "$volume" -e -2)

    if test (pactl -- get-sink-mute 0 | awk -F":" '{print $2}' | string trim) = "no"
        set muted "false"
    else
        set muted "true"
    end

    echo "{\"muted\":$muted,\"level\":\"$level\"}"
end

function set_volume
    pactl -- set-sink-volume 0 "$argv[1]%"
end

function toggle_mute
    pactl -- set-sink-mute 0 toggle
end

function subscribe
    echo (get_volume)
    pactl subscribe | while read -l event
        if string match -e "sink" $event > /dev/null
            echo (get_volume)
        end
    end
end

switch $argv[1]
    case get
        get_volume
    case set
        set_volume $argv[2]
    case mute
        toggle_mute
    case subscribe
        subscribe
end
