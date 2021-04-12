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



#Empezamos a crear nuestras herramientas en bash ejemplo - curso s4vitar
function cdf(){
        cd ../..
        cd ../..
        cd ..
        cd /home/pro/Escritorio/CPHE/

}


function mki(){
                mkdir $1
                cd $1

}

function mkc(){
                mkdir {nmap,content,scrips,tmp,exploits}
                cd nmap/
}

function extracPorts(){

        echo -e "\n${yellowColour}[*] Extracting information .......${endColour}\n"

        ip_adress=$(cat allports | grep -oP "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" | sort -u)
        open_ports=$(cat allports | grep -oP "\d{1,5}/open" | cut -d '/' -f 1 | xargs | tr ' ' ',')

        echo -e "\t${blueColour}[*]IP ADDRESS: ${endColour}${grayColour}$ip_adress${endColour}"
        echo -e "\t${blueColour}[*]OPEN PORTS: ${endColour}${grayColour}$open_ports${endColour}\n"
        echo -e "\n${yellowColour}[*] Listo Para el Hacking [*]${endColour}\n"
        echo $open_ports | tr -d '\n' | xclip -sel clip
        echo -e "\n${yellowColour}[*] Los Puertos han sido copiados to clipboard .......${endColour}\n"
}
