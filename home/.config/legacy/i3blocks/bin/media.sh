#!/bin/sh

case $BLOCK_BUTTON in
	3) herbe "Media Module" "Displays the current media playing" ;;
esac

media=$(playerctl metadata --format "{{ artist }} - {{ title }}") 

if [ ${#media} -gt 40 ]; then
	media=$(echo "$media" | cut -c 1-40)
	media="$media..."
fi

if [ "$media" ]; then
	echo "<span color=\"#b48ead\">󰎈 </span> $media"
else
	echo "<span color=\"#b48ead\">󰽳</span>"
fi
