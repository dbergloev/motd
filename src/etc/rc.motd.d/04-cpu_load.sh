#!/bin/bash

#
# Calculate the CPU Usage
#
#cpu_load=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1); }' \
#            <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat) \
#                | awk '{printf "%.2f", $1}')
#
#echo "@list CPU load: $cpu_load%"

cores=$(grep -c ^processor /proc/cpuinfo 2>/dev/null)
loadavg1=$(cut -f1 -d ' ' /proc/loadavg)
loadavg5=$(cut -f2 -d ' ' /proc/loadavg)

if [ $cores -eq 0 ]; then
    cores=1
fi

load=$(echo "$loadavg1 / $cores" | bc -l | awk '{printf "%.2f", $1}')

if [ $(echo "$loadavg1 > $loadavg5" | bc) -eq 1 ]; then
    load="${load}\u2191"
fi

echo -e "@list System load: $load"

