#!/bin/sh

low="󰕿 "
hi="󰕾 "
med="󰖀 "
mute="󰝟"

# Mouse actions
case $BLOCK_BUTTON in
	1) amixer --quiet sset Master toggle ;;
	4) amixer --quiet set Master 5%+  ;;
	5) amixer --quiet set Master 5%-  ;;
esac

volume=$(amixer sget Master | grep -o '1\?[0-9]\?[0-9]%' | tr -d '%')

get_vol_icon() {
	if [ "$volume" -gt 50 ]; then
		echo " $hi$volume "
	elif [ "$volume" -gt 25 ]; then
		echo " $med$volume "
	else
		echo " $low$volume "
	fi
}

if amixer get Master | grep -q '\[on\]'; then
	get_vol_icon
else
	echo " $mute "
fi
