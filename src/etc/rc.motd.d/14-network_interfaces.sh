#!/bin/bash

declare dev ip stat
declare ipexp='[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+'

for dev in `ip -brief link | awk '$1 !~ "lo|@" { print $1}'`; do
    stat=$(ip -brief address show $dev 2>/dev/null | awk '{print $3}')
    
    if [ -n "$stat" ] && grep -qe "$ipexp" <<< "$stat"; then
        echo -n "@list IPv4 for $dev: "
    
        for ip in `ip -brief address show $dev | grep -oe "$ipexp"`; do
            echo -n $ip
            echo -n " "
        done
        
        echo ""
    fi
done
