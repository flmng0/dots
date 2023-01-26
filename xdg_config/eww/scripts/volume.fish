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

# TODO: Subscribe to volume using pactl
# https://stackoverflow.com/questions/34936783/watch-for-volume-changes-in-alsa-pulseaudio

switch $argv[1]
    case get
        get_volume
    case set
        set_volume $argv[2]
    case mute
        toggle_mute
end
