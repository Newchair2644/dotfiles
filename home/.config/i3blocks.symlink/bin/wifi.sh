#!/bin/sh

ws_l="󰤫 󰤟 󰤢 󰤥 󰤨 "
ws_n="󰤭 "

dev="$(ip route show | grep '^default' | cut -d' ' -f5)"
ssid="$(iw dev "$dev" link | grep 'SSID:' | cut -c 8-)"
signal="$(grep "$dev" /proc/net/wireless | awk '{ printf "%.0f\n", $3 / 14 }')"

if [ "$ssid" ]; then
	printf " %s  $ssid \n" "$(echo "$ws_l" | cut -d' ' -f"$signal")"
else
	printf " %s No Internet \n" "$ws_n"
fi