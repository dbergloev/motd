#!/bin/bash

echo "@head"

if [ -f /etc/lsb-release ] || which lsb_release >/dev/null 2>&1; then
    if [ -f /etc/lsb-release ]; then
        descr="$(grep 'DISTRIB_DESCRIPTION' /etc/lsb-release | awk -F'"' '{print $2}')"
        
    else
        descr="$(lsb_release -a | grep 'Description:' | cut -f2-)"
    fi

    if [ -n "$descr" ]; then
        echo -en "\033[02;37m$descr ("
        echo -n "$(uname -s) $(uname -r | grep -oe '^\([0-9]\+\.\?\)\+') $(uname -m)"
        echo -e ")\033[0m"
    fi
fi

echo -e "\033[02;37m$(awk -F '[ :][ :]+' '/^model name/ { print $2; exit; }' /proc/cpuinfo)\033[0m"
echo -e "\033[02;37m$(free -t -m | grep "Mem" | awk '{print $2" MiB";}') of memory\033[0m"
echo ""
echo "  System information as of $(date +'%a %b %d %T %Y')"

cat <<'EOF'

     \\033[02;36m .--.     
     \\033[02;36m|o_o |     _   _
     \\033[02;36m|:_/ |    | | (_)_ __  _   ___  __ 
    \\033[02;36m//   \\\\ \\\\   | | |\\033[00;37m | '_ \\\\| | | \\\\ \\\\/ /\\033[0m
   \\033[02;36m(|     | )  | |_|\\033[00;37m | | | | |_| |>  < \\033[0m 
  \\033[02;36m/'\\\\_   _/`\\\\  |___|\\033[00;37m_|_| |_|\\\\__._/_/\\\\_\\\\\\033[0m
  \\033[02;36m\\\\___)=(___/\\033[0m  
EOF

