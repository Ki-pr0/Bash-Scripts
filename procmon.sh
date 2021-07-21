#!/bin/bash

#creamos una variable para que almacene todos los procesos

old_process=$(ps -eo commands)

#creamos un bucle de itineracion infinita para que contantamente se cree una 
#nueva variable llamada new_process que va a tener una diferencia de tiempo en comandos con la otra variable
while true; do
        new_process=$(ps -eo command)
#usamos el comando diff para que nos imprima el resultado de la variable vieja con la nueva y nos quite los procesos procmon o command (este script) y grepee por los simbolos de mayor o menor para ver los cambios de procesos
        diff <(echo "$old_process") <(echo "$new_process") | grep -v  -E "procmon|command" | grep "[\>\<]"
        old_process=$new_process
done
