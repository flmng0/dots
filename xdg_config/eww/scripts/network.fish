#!/usr/bin/env fish

set -l output (nmcli -t -f SIGNAL,ACTIVE device wifi)

for line in $output
    set -l parts (string split ':' $line)
    if test $parts[2] = "yes"
        echo $parts[1]
        break
    end
end
