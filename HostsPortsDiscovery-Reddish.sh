#!/bin/bash
# Descubrimiento de Puertos para los Siguientes Hosts encontrados en la Maquina Reddish
hosts=("172.18.0.1" "172.19.0.1" "172.19.0.2" "172.19.0.3")

for host in ${hosts[@]}; do
        echo -e "\n[+]Scanning ports in $host \n"
        for port in $(seq 1 10000); do
                timeout 1 bash -c "echo '' > /dev/tcp/$host/$port" 2> /dev/null && echo -e "\t[*] Puerto: $port - ABIERTO [*]" &
        done; wait
done
