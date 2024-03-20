#!/bin/bash
#844781, Martínez Pérez, Jorge, M, 3, B
#sudo userdel usus

if [ "$(id -u)" != 0 ]
then
    echo "Este script necesita privilegios de administracion"
    exit 1
fi

if [ $# != 2 ]
then
    echo "Numero incorrecto de parametros"
    exit 2
fi

parametro=$1
fichero=$2

if [ "$parametro" != "-a" -a "$parametro" != "-s" ]
then
    echo "Opcion invalida"
    exit 3
fi

while read -r line
do
    echo "$line"
    user=$(echo $line | cut -d',' -f1)
    password=$(echo $line | cut -d',' -f2)
    nombre=$(echo $line | cut -d',' -f3)
    echo "Usuario: $user"
    echo "Password: $password"
    echo "Nombre: $nombre"

    if [ "$parametro" = "-s" ]
    then
        backup="$home/../../extra/backup"
        mkdir -p "$backup"
        if [ ! -e "$backup" ]
        then
            echo "Error inesperado, no existe $backup"
        fi
        tar cvzf "$user".tar "$home"/"$user"/*
        mv "$user".tar "$backup"
        if [ -e "$backup"/"$user".tar ]
        then
            #userdel "$user"
            echo "$user borrado"
        else
            echo "Error"
        fi
    else
        #añadir usuario
        if [ -z "$user" -o -z "$password" -o -z "$nombre" ]
        then
            echo "Campo invalido"
            exit 4
        fi
        useradd -c "$nombre" "$user" -m -k /etc/skel -K UID_MIN=1815 -U 2>/dev/null
        if [ "$?" != 0 ]
        then
            echo "El usuario $user ya existe"
        else
            echo "$user:$password" | chpasswd
            usermod "$user" -f 30
            echo "$nombre ha sido creado"
        fi
    fi
done < $fichero