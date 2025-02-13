#!/usr/bin/env bash

# if hyprsunset is running kill it
# else run it
if pgrep -x "hyprsunset" >/dev/null; then
	pkill hyprsunset
else
	hyprsunset
fi
