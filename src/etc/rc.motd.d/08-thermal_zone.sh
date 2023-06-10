#!/bin/bash

declare file list
declare cur_temp=0
declare max_temp=-1
declare -a files=( "/sys/devices/pci0000:00/*/hwmon/*/temp1_input" "/sys/devices/virtual/thermal/*/*/temp1_input" )

for list in "${files[@]}"; do
    for file in $list; do
        # You may get a 'No data available' error from the kernel on some of these files
        if cat $file >/dev/null 2>&1; then
            cur_temp=$(cat $file)
        
            if [ $cur_temp -gt $max_temp ]; then
                max_temp=$cur_temp
            fi
        fi
    done
done

if [ $max_temp -eq -1 ]; then
    echo "@list Temperature: N/A"

else
    echo "@list Temperature: $(echo "scale=1;$max_temp/1000" | bc)°C"
fi
