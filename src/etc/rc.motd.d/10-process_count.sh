#!/bin/bash

declare procs=0 zombies=0

for i in cat /proc/*/stat; do 
    if [ -f $i ]; then
        procs=$(($procs + 1))
        
        if [ "Z" = "`head -n 1 $i | awk '{print $3}'`" ]; then
            zombies=$(($zombies + 1))
        fi
    fi
done

if [ $zombies -gt 0 ]; then
    echo "@list Processes: $procs ($zombies)"
    
else
    echo "@list Processes: $procs"
fi
