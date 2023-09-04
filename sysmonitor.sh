#!/bin/bash

C="\e[0;33m"
R="\e[0m"

bat() {
    # does dir exist
    if [ -d "/sys/class/power_supply/BAT0" ]; then
        capacity=$(cat /sys/class/power_supply/BAT0/capacity)
        echo "$capacity"
    else
        echo "not found"
    fi
}

analysis() {
    printf "\033[H\033[2J" # ctrl l equivalent
    echo
    echo -e "${C}$(whoami)@$(hostname)${R} | System Analysis"
    echo
    echo "======================================================"
    echo "Scanned At: $(date)"
    echo
    echo "======================================================"
    echo "CPU Usage: $(top -bn1 | awk 'NR > 7 && $1 ~ /^[0-9]+$/ { sum += $9 } END { print sum }')"
    # top utility in batch mode for one iteration, -n1 pulls sys info once then exits
    # awk ignores headers, pulls cpu info from the ninth column, and adds the values together
    echo "RAM Usage: $(free -m | awk '/Mem/{printf "%.2f%", $3/$2*100}')"
    # free -m shows mem stats in MB
    # awk searches for lines containing mem and calculates RAM usage by dividing col 3 (used mem) by col 2 (total mem) and * 100 for percentage
    echo "GPU Usage:"
    echo "Battery: $(bat)%"
    echo
    echo "Disk Space:"
    df -h
    echo "======================================================"
}

# has to be before while true do loop or it doesn't work
end_screen() {
    tput cnorm
    tput cup 21 0 # cursor at bottom of screen, ensures no lines are cut off when exiting
    echo "[*] Exited Successfully"
    stty echo
    exit 0
}

trap end_screen EXIT


name=$(echo -e "${C}$(whoami)@$(hostname)${R}")
neo_mod="\n           $name | System Specs\n"
divider="================================================="



# newline at the top of the neofetch block, modded the first line text, changed the divider
# just the newline: awk '{print (NR==1 ? "\n" : "") $0}'
left=$(analysis)
right=$(neofetch --stdout | awk -v mod="$neo_mod" -v div="$divider" 'NR==1 {print mod} NR==2 {print div} NR!=1 && NR!=2 {print}')



# determine which column has more lines and choosing the greater number
left_lines=$(echo "$left" | wc -l)
right_lines=$(echo "$right" | wc -l)
max_lines=$((left_lines > right_lines ? left_lines : right_lines))


# iterates from 1 to max lines
for ((i = 1; i <= max_lines; i++)); do
    # extract the i-th line, quit after reading it and delete remaining lines, ensuring only that one line is extracted/ formatted
    left_line=$(sed "${i}q;d" <<< "$left")
    right_line=$(sed "${i}q;d" <<< "$right")
    printf "%-65s %-55s\n" "$left_line" "$right_line"
done

# continuously update the changing values
while true; do
    tput civis
    stty -echo # remove terminal echo so ^C doesn't appear
    # move the cursor to the lines containing changing values, lines include name and $, so clear initially
    tput cup 7 0
    echo "CPU Usage: $(top -bn1 | awk 'NR > 7 && $1 ~ /^[0-9]+$/ { sum += $9 } END { print sum }')"
    tput cup 8 0
    echo "RAM Usage: $(free -m | awk '/Mem/{printf "%.2f%", $3/$2*100}')"
    tput cup 9 0
    echo "GPU Usage:"
    tput cup 10 0
    echo "Battery: $(bat)%"

    sleep 0.2
done
