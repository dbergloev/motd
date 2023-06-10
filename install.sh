#!/bin/bash

if ! sudo true; then
    echo "You need root privileged to install this"; exit 1
fi

sudo cp -a src/* /
sudo chmod +x /etc/rc.motd
sudo chmod +x /etc/rc.motd.d/*.sh

for file in /etc/pam.d/*; do
    if grep -q 'pam_motd.so' $file; then
        found=0
    
        while IFS=""; read line; do
            if grep -qe '^\bsession' <<< "$line" && grep -qe '\(pam_motd.so\|/usr/bin/update-motd\)' <<< "$line"; then
                if [ $found -eq 0 ]; then
                    echo "session  optional  pam_exec.so  stdout /usr/bin/update-motd" | sudo tee -a ${file}.bak >/dev/null
                    echo "session  optional  pam_motd.so  motd=/etc/motd" | sudo tee -a ${file}.bak >/dev/null
                    
                    found=1
                fi
            
            else
                echo "$line" | sudo tee -a ${file}.bak >/dev/null
            fi
        
        done < $file
        
        sudo mv ${file}.bak $file
    fi
done

cat <<'EOF' | sudo tee /usr/bin/update-motd >/dev/null
#!/bin/bash
#

##
# Do not process this during a graphical login.
# It will mess up the DM and also it's wasted resources.
#
if [ -n "$PAM_TYPE" ] && ( ! grep -qe '^\(ssh\|/dev/tty\)' <<< "$PAM_TTY" || ! grep -qe '^\(sshd\|login\)$' <<< "$PAM_SERVICE" ); then
    rm /etc/motd 2>/dev/null; exit 0
fi

cores=$(grep -c ^processor /proc/cpuinfo 2>/dev/null)
load=$(cut -f1 -d ' ' /proc/loadavg)

if [ $cores -eq 0 ]; then
    cores=1
fi

threshold=$(echo "${cores:-1}.0 * 0.95")
avg=$(echo "$load < $threshold" | bc)

if [ $avg -eq 1 ]; then
    /etc/rc.motd > /etc/motd

else
    # Note that System load is not equal to CPU load, 
    # although the latter can be the cause of the first. 
    echo -e "\n  System load threshold exceeds 95%\n" > /etc/motd
fi
EOF

sudo chmod +x /usr/bin/update-motd

