#!/usr/bin/env fish

bspc query -T --monitor
bspc subscribe desktop | while read -l _
    bspc query -T --monitor
end
