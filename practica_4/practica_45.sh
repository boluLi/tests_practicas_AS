#!/bin/bash

# Este script permite añadir y quitar usuarios de las maquinas especificadas
# en un fichero que se pasa como parametro.
# Los usuarios a borrar/añadir han de estar especificados en otro fichero, que tambien
# se pasa como parametro.
#
# ./practica_4.sh [-a/-s] usuarios maquinas
#
# -a: añade usuarios.
# -s: elimina usuarios
#
# El fichero de las maquinas debe contener una ip por linea.
# El fichero de los usuarios esta descrito su estructura en el practica_3.sh

# Comprobamos el numero de parametros
if [ $# -ne 3 ]; then
    # Si NO es igual a 3 el numero de parametros mensaje de error
    echo "Numero incorrecto de parametros" 1>&2
    exit 1
else
    # Recorremos el fichero con las direcciones ip de las maquinas y les pasamos practica_3.sh, ademas del fichero de usuarios
    while read -r ip; do
        if ping -c 1 "$ip" >/dev/null; then
            scp -q -i "~/.ssh/id_as_ed25519" "./practica_3.sh" "as@$ip:~"
            ssh -q -i "~/.ssh/id_as_ed25519" "as@$ip" "sudo ~/./practica_3.sh "$1" "$2" ; rm ~/practica_3.sh ~/$2" < /dev/null
        else
            # se muestra un mensaje de error si no nos podemos conectar a la maquina indicada
            echo "No se ha podido conectar a la maquina "$ip"" 1>&2
        fi
    done < "$3"
fi
