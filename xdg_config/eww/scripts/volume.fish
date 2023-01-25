#!/usr/bin/env fish

function get_volume
    set -l output (amixer sget Master)

    set -l parts (echo $output | awk -F"[][]" '/Left:/ { print $2; print $4 }')

    set -l level (string sub $parts[1] -e -1)
    if test "$parts[2]" = "on"
        set muted "false"
    else
        set muted "true"
    end
    echo "{\"muted\":$muted,\"level\":\"$level\"}"
end

function set_volume
    amixer sset Master "$argv[1]%" > /dev/null
end

function toggle_mute
    amixer sset Master toggle > /dev/null
end

switch $argv[1]
    case get
        get_volume
    case set
        set_volume $argv[2]
    case mute
        toggle_mute
end
