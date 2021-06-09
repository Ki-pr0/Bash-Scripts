#!/bin/bash

# Comando para enumerar desde la ruta /var/ en busca de credenciales para escalar Privilegios desde nuestra ruta actual

$ find . -iname '*config*' -type f -exec grep -nie 'pass.*=' --color=always /dev/null {} \;

# Buscando por permisos SUID a nivel de root para escalar privilegios

$ find / -perm -u=s -type f 2>/dev/null

# Busqueda de archivos interesantes con el nombre +config+

$ find \-name config* -type f 2>/dev/null
 
$ find \-name *config* -type f 2>/dev/null

# Grepeando desde la ruta /var/www/ para encontrar ficheros de manera recursiva que contengan el multiple matching de estas palabras

/var/www $ grep -r -i -E "user|pass|auth|key|db|database"

# Variaciones para reducir los contenidos listados y poder asimilarlos al verlos o buscar informacion

$ grep -r -i -E "user|pass"
$ grep -r -i -E "auth|key|db|database"
