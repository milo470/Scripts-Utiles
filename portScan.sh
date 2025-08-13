#!/bin/bash
#Script que valida en todos los puertos cuales están abiertos
#Ctrl+C
function ctrl_c() {
    echo -e "\n\nSaliendo del script...."
    exit 1
}

trap ctrl_c SIGINT
#-------------------------------------------

declare -a ports=($(seq 1 65535)) #Crea un array con todos los ports posibles

function checkPort() {
    (exec 3<>/dev/tcp/$1/$2) 2>/dev/null
    if [ $? -eq 0 ]; then #Si el codigo de estado es 0
        echo -e "\n[+] Host: $1 - Port $2 (OPEN)"
    fi
    exec 3<&-
    exec 3>&-
}

if [ $1 ]; then
    for port in "${ports[@]}"; do
        checkPort $1 $port &
    done
else
    echo -e "\n [!] Uso: $0 <ip-addresss>"
fi

wait
