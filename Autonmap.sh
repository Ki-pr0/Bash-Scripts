#!/bin/bash

# Autor Surf3rH4ck

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function helpPannel(){
        echo -e "\m Uso: $0 + IP a Escanear con Nmap\n"
        echo -e "\n Aprende a usar la Herramienta Payaso\n"
        exit 1
}
# Cogiendo el Ctrl + C para poder parar la ejecucion del programa
trap ctrl_c INT

function ctrl_c(){
        echo -e "\n${yellowColour}[*]${endColour}${greyColour}Saliendo [*]${endColour}"
        exit 0
}

if [ $1 != null ]; then
        ip=$1
        echo -ne "\n${redColour}[*] Introducida la IP:${endColour}${greenColour} $ip${endColour}${redColour} a escanear [*]${endColour}\n" 
        echo -e "\n${blueColour}[*] ${endColour}${greenColour} Lanzando Nmap con el scaneo de abajo:${endColour}\n"
        echo -e "\t${blueColour}nmap -p- --open -sS --min-rate 4000 -n -Pn $ip -oG allports${endColour}"
        nmap -p- --open -sS --min-rate 4000 -n -Pn $ip -oG allports &>/dev/null
        echo -e "\n${purpleColour}[+] Guardando los puertos en el archivo:${endColour}${greenColour} allports${endColour} "
        sleep 3
        ip_adress=$(cat allports | grep -oP "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" | sort -u)
        open_ports=$(cat allports | grep -oP "\d{1,5}/open" | cut -d '/' -f 1 | xargs | tr ' ' ',')
        echo -e "\n\t${blueColour}[*]IP ADDRESS: ${endColour}${grayColour}$ip_adress${endColour}"
        echo -e "\t${blueColour}[*]OPEN PORTS: ${endColour}${grayColour}$open_ports${endColour}\n"

        sleep 10
        echo -e "\n${redColour}[*]${endColour}${greenColour}Empezando el Escaneo de Version y Servicio de los Puertos Abiertos${endColour}\n"
        nmap -sC -sV -p$(echo $(echo $open_ports | tr -d '\n') $ip_adress -oN target)
        echo -e "\n${blueColour}[*]${endColour}${purpleColour} Guardando los Resultados en el archivo:${endColour}${greenColour} target${endColour}"
        sleep 15
        echo -ne "\n${redColour}[*]${endColour}${greenColour} Procedemos con el script${endColour}${yellowColour} http-enum?? yes/si no/enter ${endColour}\n" && read answer
        if [ $answer == "si" ]; then
                echo -ne "\n${redColour}[*]${endColour}${greenColour} Especifica el ${endColour}${yellowColour} Puerto http ${endColour}\n" && read port
                nmap --script http-enum -p$port $ip -oN WebScan &>/dev/null
                echo -e "\n${blueColour}[*]${endColour}${purpleColour} Guardando los Resultados en el archivo:${endColour}${greenColour} Webscan${endColour}"
                sleep 5
                cat WebScan 
                sleep 10
        else
                echo -e "\n${greenColour}Que Tengas un Buen Dia Hack${endColour}\n"
                exit 0
        fi
else
        helpPannel
        break; exit 1
fi
