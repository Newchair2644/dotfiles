#!/bin/sh

pow="$(cat /sys/class/power_supply/BAT0/capacity)"
po="$((pow / 10 + 1))"

if grep -q 'Discharging' /sys/class/power_supply/BAT0/status; then
	icons="󱃍 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰂄 "
else
	icons="󰢟 󰢜 󰂆 󰂇 󰂈 󰢝 󰂉 󰢞 󰂊 󰂋 󰂄 "
fi

printf " %s $pow \n" "$(echo "$icons" | cut -d' ' -f"$po")"