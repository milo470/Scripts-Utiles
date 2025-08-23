#!/bin/bash
#Monitor de procesos en tiempo real que detecta cuando se crean o eliminan procesos en el sistema
function ctrl_c() {
    echo -e "\n\n Saliendo ......."
    tput cnorm
    exit 1
}

#Ctrl + C
trap ctrl_c SIGINT

old_process=$(ps -eo user,command)

tput civis

while true; do
    new_process=$(ps -eo user, command)
    diff <(echo "$old_process") <(echo "$new_process") | grep "[\>\<]" | grep -vE "command|kworker|procmon"
    old_process=$new_process

done
