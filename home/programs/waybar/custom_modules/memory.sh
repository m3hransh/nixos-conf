#!/usr/bin/env bash

text=$(free -h | grep Mem | awk '{print $3}' | sed -e 's/\(\d*[MG]\).*/\1/')
tooltip="$text used"
echo '{"text": "'${text}'", "tooltip": "'$tooltip'", "class": "$class"}'
