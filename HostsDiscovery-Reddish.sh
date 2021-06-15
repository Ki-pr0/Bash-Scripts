#!/bin/bash
# Maquina Reddish HTB - Descubriendo Hosts Activos
hosts=("172.18.0" "172.19.0")

for host in ${hosts[@]}; do
        echo -e "\n[+]Enumerating $hosts.0/24\n"
        for i in $(seq 1 254); do
                timeout 1 bash -c "ping -c 1 $host.$i" &>/dev/null && echo "[*] Host: $host.$i ACTIVE [*]" &
        done; wait
done

