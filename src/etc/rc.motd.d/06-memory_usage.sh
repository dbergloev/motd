#!/bin/bash

declare line headline i=0
declare -a stats=(0 0 0 0 0 0) # MemTotal, MemFree, Buffers, Cached, SwapTotal, SwapFree

while read line; do
    headline=$(cut -d ':' -f 1 <<< "$line")
    
    case $headline in
        MemTotal) i=0;;
        MemFree) i=1;;
        Buffers) i=2;;
        Cached) i=3;;
        SwapTotal) i=4;;
        SwapFree) i=5;;
        
        *) continue;;
    esac
    
    stats[$i]=$(awk '{print $2}' <<< "$line")
    
done < /proc/meminfo

echo "@list Memory usage: $(echo "scale=0;100 - 100 * (${stats[1]} + ${stats[2]} + ${stats[3]}) / ${stats[0]}" | bc)%"

if [ $(cat /proc/swaps | wc -l) -gt 1 ]; then
    if [ ${stats[0]} -gt 0 ]; then
        echo "@list Swap usage: $(echo "scale=0;100 - 100 * ${stats[5]}/${stats[4]}" | bc)%"
        
    else
        echo "@list Swap usage: 0%"
    fi
    
else
    echo "@list Swap usage: N/A"
fi
