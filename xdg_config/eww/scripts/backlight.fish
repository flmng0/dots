#!/usr/bin/env fish

function set_bl
    brightnessctl set "$argv[1]%" > /dev/null
end

function get_bl
    set -l max (brightnessctl max)
    set -l val (brightnessctl get)

    echo (math "100 * $val / $max")
end

switch $argv[1]
    case set
        set_bl $argv[2]
    case get
        get_bl
end
