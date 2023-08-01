#!/bin/sh

updates=$(checkupdates | wc -l)

if [ "$updates" -gt 0 ]; then
	echo "󰣇 $updates"
else
	printf "󰄭 "
fi
