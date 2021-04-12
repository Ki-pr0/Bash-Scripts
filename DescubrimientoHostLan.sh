#!/bin/bash
#programa para enumerar los host de tu segmento de red 

for i in $(seq 2 254) ; do
        timeout 1 bash -c "ping -c 1 192.168.233.$i >/dev/null 2>&1" && echo "[*] EL Equipo: 192.168.233.$i esta Activo" &

done
