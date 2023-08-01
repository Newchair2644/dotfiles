#!/bin/bash

# array index for current clock
hour=$(date '+%_I')

# array with material design icon clocks
clocks=( "󱐿 " "󱑀 " "󱑁 " "󱑂 " "󱑂 " "󱑄 " "󱑅 " "󱑆 " "󱑇 " "󱑈 " "󱑉 " "󱑊 " )

echo " ${clocks[$hour-1]} "
