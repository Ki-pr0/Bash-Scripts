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

#Creacion de una funcion que crea directorio [$1] y movimiento al directorio nuevo
function mki(){
                mkdir $1
                cd $1

#Creacion de una funcion que nos crea 5 directorios para trabajar organizados
}

function mkc(){
                mkdir {nmap,content,scrips,tmp,exploits}
                cd nmap/
}

# Funcion que nos extrae los resultados de una captura de nmap en formato -oG Grepeable y con la utilidad xclip nos copia los Puertos ~ Abiertos en la clipboard
function extracPorts(){

        echo -e "\n${yellowColour}[*] Extracting information .......${endColour}\n"

        ip_adress=$(cat allports | grep -oP "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" | sort -u)
        open_ports=$(cat allports | grep -oP "\d{1,5}/open" | cut -d '/' -f 1 | xargs | tr ' ' ',')

        echo -e "\t${blueColour}[*]IP ADDRESS: ${endColour}${grayColour}$ip_adress${endColour}"
        echo -e "\t${blueColour}[*]OPEN PORTS: ${endColour}${grayColour}$open_ports${endColour}\n"
        echo -e "\n${yellowColour}[*] Listo Para el Hacking [*]${endColour}\n"
        echo $(echo $open_ports | tr -d '\n') $ip_adress "-oN nmap"| xclip -sel clip
        echo -e "\n${yellowColour}[*] Los Puertos han sido copiados to clipboard .......${endColour}\n"
}
