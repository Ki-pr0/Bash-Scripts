#!/bin/bash
#Declaramos una variable que la llamamos file = al output final que queremos "message.decrypted" 
#con el echo -e leemos la variable
#En la opcion "-aes-256-cbc" puede ser otro tipo de encryptacion 
declare -r file="message.decrypted"

while read password; do
    echo $password
    openssl -aes-256-cbc -d in message.crypted -out message.decrypted -k $password
    if [ $("echo $?") == "0" ]; then
        echo -e "\n[*] La password es $password\n" && cat $file
        rm $file && break
    fi        
done </usr/share/wordlist/rockyou.txt