#!/usr/bin/env bash

if pgrep -x "hyprsunset" >/dev/null; then
	printf '{"text": "", "tooltip": "Sunset on", "class" : "%s"}\n' "$CLASS"
else
	printf '{"text": "", "tooltip": "Sunset off", "class" : "%s"}\n' "$CLASS"
fi
