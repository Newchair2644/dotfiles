#!/bin/sh

if [ -z "$1" ]; then
	echo "Device was not provided"
	exit
fi

ssid="$(iw dev "$1" info | grep "^\s*ssid\s.*" | cut -c 7-)"

if [ -z "$ssid" ]; then
    echo "No Internet"
else
    echo "$ssid"
fi
