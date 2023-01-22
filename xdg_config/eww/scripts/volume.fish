#!/usr/bin/env fish

set -l output (amixer sget Master)

echo $output | awk -F"[][]" '/Left:/ { print $2 }'
