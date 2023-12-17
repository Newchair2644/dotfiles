#!/bin/bash

# https://ao.vern.cc/questions/9229333/how-to-get-overall-cpu-usage-e-g-57-on-linux

grep 'cpu ' /proc/stat | \
    awk '
    {u=$2+$4; t=$2+$4+$5;
    if (NR==1) {
        u1=u;
        t1=t;
    } else
        printf "   %.2f% \n", ($2+$4-u1) * 100 / (t-t1);
    }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat)
