#!/usr/bin/env fish

function get_status
    set -l output (nmcli -t -f SIGNAL,ACTIVE,SSID device wifi)

    for line in $output
        set -l parts (string split ':' $line)
        if test $parts[2] = "yes"
            echo "{\"name\":\"$parts[3]\",\"strength\":$parts[1]}"
            break
        end
    end
end

function toggle
    if test -z (get_status)
        echo 'Enabling Wi-Fi'
        nmcli radio wifi on
    else
        echo 'Disabling Wi-Fi'
        nmcli radio wifi off
    end
end

switch $argv[1]
    case get
        get_status
    case toggle
        toggle
end
