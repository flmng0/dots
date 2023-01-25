#!/usr/bin/env fish

function is_enabled 
    set -l state (bluetoothctl show | grep 'Powered' | string split " ")

    if test "$state[2]" = "yes"
        echo 'true'
    else
        echo 'false'
    end
end

function get_status

    set -l enabled (is_enabled)

    set -l devices (bluetoothctl devices Connected | head -n 1 | string split " ")
    set -l device_name $devices[3..-1]

    echo "{\"enabled\":$enabled,\"device\":\"$device_name\"}"
end

function toggle
    if test (is_enabled) = "true"
        bluetoothctl power off
    else
        bluetoothctl power on
    end
end

switch $argv[1]
    case get
        get_status
    case toggle
        toggle
end
