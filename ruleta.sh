#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Ctrl + c
trap ctrl_c INT

function ctrl_c() {
    echo -e "\n\n Saliendo del programa....."
    tput cnorm
    exit 1

}

function helpPanel() {
    echo -e "\n------------ Bienvenido a la ruleta---------
    \n------------Como usar este script------------
    \n Ingresa -m y la cantidad de dinero que vas a usar
    \n Ingresa -t y la tecnica de ruleta a usar (martingala/inverseLabrouchere)\n"
}
function martinGala() {
    echo -e "\n[+] Dinero actual: $money$"
    echo -ne "[+] Cuanto dinero deseas apostar? -> " && read initial_bet
    echo -ne "[+] Deseas realizar la apuesta con par o impar? -> " && read par_impar
    echo -e "\n[+] Vamos a jugar una cantidad iniciar de $initial_bet$ a $par_impar"
    play_counter=0   #Contador de jugadas
    jugadas_malas="" #Contador de jugadas malas
    tput civis       #Ocultar el cursor
    initial_backup=$initial_bet
    while true; do
        money=$(($money - $initial_bet))

        echo -e "\nAcabas de apostar $initial_bet$ y tienes $money$"
        #$RANDOM%37 devuelve randoms del 0 al 36
        random_number="$(($RANDOM % 37))"
        echo -e "\nHa salido el numero: $random_number"
        if [ ! "$money" -lt 0 ]; then
            if [ "$par_impar" == "par" ]; then    #AQUI SE GANA SI ES PAR
                if [ $random_number -eq 0 ]; then #SI ES 0
                    echo -e "\n${redColour}El numero es 0, ¡PIERDES!${endColour}"
                    initial_bet=$(($initial_bet * 2))
                    jugadas_malas+="$random_number "
                    echo -e "\n${yellowColour}Dinero total: $money$ ${endColour}"
                elif [ $(($random_number % 2)) -eq 0 ]; then #SI ES PAR
                    echo -e "\n${greenColour}el numero es par, ¡GANAS!${endColour}"
                    reward=$(($initial_bet * 2))
                    echo -e "\nGanas un total de $reward$"
                    money=$(($money + $reward))
                    initial_bet=$initial_backup
                    echo -e "\n${yellowColour}Dinero total: $money$ ${endColour}"
                    jugadas_malas=""

                else #SI ES IMPAR
                    echo -e "\n${redColour}El numero es impar, ¡PIERDES!${endColour}"
                    initial_bet=$(($initial_bet * 2))
                    echo -e "\n${yellowColour}Dinero total: $money$ ${endColour}"
                    jugadas_malas+="$random_number "
                fi

            elif [ "$par_impar" == "impar" ]; then #AQUI SE GANA SI ES IMPAR
                if [ $random_number -eq 0 ]; then  #SI ES 0
                    echo -e "\n${redColour}El numero es 0, ¡PIERDES!${endColour}"
                    initial_bet=$(($initial_bet * 2))
                    jugadas_malas+="$random_number "
                    echo -e "\n${yellowColour}Dinero total: $money$ ${endColour}"
                elif [ $(($random_number % 2)) -eq 1 ]; then #SI ES IMPAR
                    echo -e "\n${greenColour}el numero es impar, ¡GANAS!${endColour}"
                    reward=$(($initial_bet * 2))
                    echo -e "\nGanas un total de $reward$"
                    money=$(($money + $reward))
                    initial_bet=$initial_backup
                    echo -e "\n${yellowColour}Dinero total: $money$ ${endColour}"
                    jugadas_malas=""

                else #SI ES PAR
                    echo -e "\n${redColour}El numero es par, ¡PIERDES!${endColour}"
                    initial_bet=$(($initial_bet * 2))
                    echo -e "\n${yellowColour}Dinero total: $money$ ${endColour}"
                    jugadas_malas+="$random_number "
                fi
            fi
        else
            echo -e "\n${redColour}NOS QUEDAMOS SIN DINERO :(${endColour}"
            echo -e "\n${redColour}Numero de jugadas: $play_counter${endColour}"
            echo -e "\n${redColour}Las malas jugadas fueron:${endColour}"
            echo -e "\n${blueColour}[$jugadas_malas]${endColour}"
            break
        fi
        let play_counter+=1
        tput cnorm

    done
    tput cnorm
}

function inverseLabrouchere() {
    echo -e "\n[+] Dinero actual: $money$"
    echo -ne "[+] Deseas realizar la apuesta con par o impar? -> " && read par_impar
    jugadas_totales=0
    declare -a secuence=(1 2 3 4)
    bet=$((${secuence[0]} + ${secuence[-1]}))
    echo -e "[+] Comenzamos con la secuencia: [${secuence[*]}]" # [*] convierte todo el array en una cadena, [@] usa todos los argumentos separados
    #secuence=("${secuence[@]:1:${#secuence[@]}-2}")
    #echo -e "[+] Apostamos $bet$ y nuestra secuencia queda en [${secuence[*]}]"
    #echo -e "[+] Apostamos $bet y nuestra secuencia queda en [${secuence[*]:1:$((${#secuence[@]} - 2))}]"

    while true; do
        let jugadas_totales+=1

        money=$(($money - $bet))
        echo -e "\n Apostamos: $bet y tenemos en total $money$"
        random_number=$(($RANDOM % 37))
        echo -e "\nHa salido el numero: $random_number"
        if [ ! "$money" -lt 0 ]; then
            if [ "$par_impar" == "par" ]; then    #AQUI SE GANA SI ES PAR
                if [ $random_number -eq 0 ]; then #SI ES 0
                    echo -e "\nEl numero es 0, ¡PIERDES!"
                    unset secuence[0]
                    unset secuence[-1] 2>/dev/null
                    echo -e "La secuencia ahora queda [${secuence[*]}]"
                    secuence=(${secuence[@]})
                    if [ "${#secuence[@]}" -gt 1 ]; then
                        bet=$((${secuence[0]} + ${secuence[-1]}))
                    elif [ "${#secuence[@]}" -eq 1 ]; then
                        bet=${secuence[0]}
                    else
                        echo -e "\n Perdimos la secuencia, restableciendo...."
                        secuence=(1 2 3 4)
                        bet=$((${secuence[0]} + ${secuence[-1]}))
                    fi
                elif [ $(($random_number % 2)) -eq 0 ]; then #SI ES PAR
                    echo -e "\nEl numero es par, ¡GANAS!"
                    reward=$(($bet * 2))
                    money=$(($money + $reward))
                    echo -e "\nTienes en total $money$"
                    secuence+=($bet)
                    secuence=(${secuence[@]})
                    echo -e "La secuenta es [${secuence[*]}]"
                    if [ "${#secuence[@]}" -ne 1 ]; then
                        bet=$((${secuence[0]} + ${secuence[-1]}))
                    elif [ "${#secuence[@]}" -eq 1 ]; then
                        bet=${secuence[0]}
                    fi

                    #sleep 2
                else #SI ES IMPAR
                    echo -e "\nEl numero es impar, ¡PIERDES!"
                    unset secuence[0]
                    unset secuence[-1] 2>/dev/null
                    echo -e "La secuencia ahora queda [${secuence[*]}]"
                    secuence=(${secuence[@]})
                    if [ "${#secuence[@]}" -gt 1 ]; then
                        bet=$((${secuence[0]} + ${secuence[-1]}))
                    elif [ "${#secuence[@]}" -eq 1 ]; then
                        bet=${secuence[0]}
                    else
                        echo -e "\n Perdimos la secuencia, restableciendo...."
                        secuence=(1 2 3 4)
                        bet=$((${secuence[0]} + ${secuence[-1]}))
                    fi
                    #sleep 2
                fi

            elif [ "$par_impar" == "impar" ]; then #AQUI SE GANA SI ES IMPAR
                if [ $random_number -eq 0 ]; then  #SI ES 0
                    echo -e "\nEl numero es 0, ¡PIERDES!"
                elif [ $(($random_number % 2)) -eq 1 ]; then #SI ES IMPAR
                    echo -e "\nEl numero es impar, ¡GANAS!"
                else #SI ES PAR
                    echo -e "\nEl numero es par, ¡PIERDES!"
                fi
            fi
        else
            echo -e "\n${redColour}NOS QUEDAMOS SIN DINERO :(${endColour}"
            echo -e "\n${redColour}Numero de jugadas: $play_counter${endColour}"
            echo -e "\n${redColour}Las malas jugadas fueron:${endColour}"
            echo -e "\n${blueColour}[$jugadas_malas]${endColour}"
            break
        fi
        let play_counter+=1
        tput cnorm
    done

}

while getopts "m:t:h" arg; do
    case "$arg" in
    m)
        money=$OPTARG
        ;;
    t)
        technique=$OPTARG
        ;;
    h)
        helpPanel
        ;;
    *)
        echo "Ingresa -h para obtener ayuda"
        ;;
    esac

done

if [ "$money" ] && [ "$technique" ]; then
    #echo "Voy a jugar con dinero:${money} y tecnica:${technique}"
    if [ "$technique" == "martingala" ]; then
        martinGala
    elif [ "$technique" == "inverseLabrouchere" ]; then
        inverseLabrouchere
    else
        echo -e "\nLa tecnica ingresada no ha sido implementada"
    fi
else
    helpPanel
fi
