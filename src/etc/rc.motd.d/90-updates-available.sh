#!/bin/bash
#
# Checks for updates on Ubuntu systems
#

update_file="/var/lib/update-notifier/updates-available"
unatt_file="/var/lib/unattended-upgrades/kept-back"

if [ -r $update_file ]; then
    cat $update_file
    
    if ! find $update_file -newermt 'now-7 days' 2> /dev/null | grep -q -m 1 '.'; then
        echo -e "@body The list of available updates is more than a week old.\nTo check for new updates run: sudo apt update"
    fi
    
elif which checkupdates >/dev/null 2>&1; then
    updates=$(checkupdates | wc -l)
    
    if [ $updates -gt 0 ]; then
        echo -e "$updates updates can be applied immediately.\nTo see these additional updates run: checkupdates"
    fi
fi

if [ -r $unatt_file ]; then
    echo "@body $(wc -w < $unatt_file) updates could not be installed automatically."
fi

