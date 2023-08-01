#!/bin/sh

ws_4="󰤨 "
ws_3="󰤥 "
ws_2="󰤢 "
ws_1="󰤟 "
ws_0="󰤫 "
ws_n="󰤭 "

if [ -z "$1" ]; then
	echo "Device was not provided"
	exit
fi

# find signal quality
ssig=$(grep "$1" /proc/net/wireless | awk '{ print int($3 * 100 / 70) }')
signal=$(echo "$ssig" | rev | cut -c 2- | rev)

get_strength() {
	case "$signal" in
		0 | 1) echo " $ws_0 " ;;
		2 | 3) echo " $ws_1 " ;;
		4 | 5) echo " $ws_2 " ;;
		6 | 7) echo " $ws_3 " ;;
		*)     echo " $ws_4 "
	esac
}

get_strength

# Update icon block
pkill -SIGRTMIN+11 i3blocks

#if ping -q -w1 -c1 1.1.1.1 &> /dev/null; then
	#get_strength
#else
	#echo "$ws_n""No Internet"
#fi
