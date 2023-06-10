#!/bin/bash

last_boot=$(date -d "now - $(awk '{print $1}' /proc/uptime) seconds" +%s)
last_boot=$(date -d "@$last_boot" +'%Y-%m-%d %H:%M')

echo "@list Last Boot: $last_boot"

