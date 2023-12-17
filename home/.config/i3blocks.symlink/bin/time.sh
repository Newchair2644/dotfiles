#!/bin/sh

time=$(date '+%I:%M %p')
hour=$(date '+%_I')
clocks="󱑋 󱑌 󱑍 󱑎 󱑎 󱑐 󱑑 󱑒 󱑓 󱑔 󱑕 󱑖 "

printf " %s $time \n" "$(echo "$clocks" | cut -d' ' -f$hour)"
