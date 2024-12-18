#!/usr/bin/env bash
token=$(gh auth token)
if [ -n "$token" ]; then
	notifications=$(curl -s -u username:${token} https://api.github.com/notifications)
	# number of notifications
	count=$(echo $notifications | jq '. | length')
	if [[ "$count" != "0" ]]; then
		echo '{"text":'$count', "tooltip":"'$tooltip'", "class":"$class"}'
	fi
fi
