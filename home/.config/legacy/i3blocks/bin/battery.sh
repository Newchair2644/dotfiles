#!/bin/sh

bat_00="󱃍 "
bat_10="󰁺 "
bat_20="󰁻 "
bat_30="󰁼 "
bat_40="󰁽 "
bat_50="󰁾 "
bat_60="󰁿 "
bat_70="󰂀 "
bat_80="󰂁 "
bat_90="󰂂 "
bat_100="󰂄 "

chr_00="󰢟 "
chr_10="󰢜 "
chr_20="󰂆 "
chr_30="󰂇 "
chr_40="󰂈 "
chr_50="󰢝 "
chr_60="󰂉 "
chr_70="󰢞 "
chr_80="󰂊 "
chr_90="󰂋 "
chr_100="󰂄 "

pow="$(cat /sys/class/power_supply/BAT0/capacity)"
po="$(echo "$pow" | rev | cut -c 2- | rev)"

get_bat() {
	case $po in
		1) echo "$bat_10$pow" ;;
		2) echo "$bat_20$pow" ;;
		3) echo "$bat_30$pow" ;;
		4) echo "$bat_40$pow" ;;
		5) echo "$bat_50$pow" ;;
		6) echo "$bat_60$pow" ;;
		7) echo "$bat_70$pow" ;;
		8) echo "$bat_80$pow" ;;
		9) echo "$bat_90$pow" ;;
		10) echo "$bat_100$pow" ;;
		*) echo "$bat_00$pow" ;;
	esac
}

get_chr() {
	case $po in
		1) echo "$chr_10$pow" ;;
		2) echo "$chr_20$pow" ;;
		3) echo "$chr_30$pow" ;;
		4) echo "$chr_40$pow" ;;
		5) echo "$chr_50$pow" ;;
		6) echo "$chr_60$pow" ;;
		7) echo "$chr_70$pow" ;;
		8) echo "$chr_80$pow" ;;
		9) echo "$chr_90$pow" ;;
		10) echo "$chr_100$pow" ;;
		*) echo "$chr_00$pow" ;;
	esac
}

if grep -q 'Discharging' /sys/class/power_supply/BAT0/status; then
	get_bat
else
	get_chr
fi
