#!/bin/sh

case $BLOCK_BUTTON in
    1) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
    4) wpctl set-volume @DEFAULT_AUDIO_SINK@ "5%+" ;;
    5) wpctl set-volume @DEFAULT_AUDIO_SINK@ "5%-" ;;
esac

vol_l="󰕿 󰖀 󰕾 󰕾 󰕾 "
vol_n="󰝟 "

vol="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed -e 's/\.//' -e 's/^Volume: //' -e 's/^0\?0\?//')"
vol_lvl="$(printf "%s 25 / 1 + p" "$vol" | dc)"

if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '\[MUTED\]'; then
    echo " $vol_n"
else
    printf " %s %s \n" "$(echo "$vol_l" | cut -d' ' -f"$vol_lvl")" "$vol"
fi
