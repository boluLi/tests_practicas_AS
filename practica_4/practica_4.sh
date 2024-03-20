#!/bin/bash
#718197, Li Yuan, Bolu, [M], [3], [B]


anyadir(){
	IFS=','
	while read usuario contra nombre
	do
		if [ "$usuario" = "" -o "$contra" = "" -o "$nombre" = "" ] #Sin campos vacios
		then
			echo "Campo invalido"
			exit 1
		fi
		ssh -n -i ~/.ssh/id_as_ed25519 as@"$2" "sudo useradd -m -U -k /etc/skel -K UID_MIN=1815 -K PASS_MAX_DAYS=30 "$usuario""#Creamos usuario mediante ssh
		if [ $? -eq 0 ]
		then
		ssh -n -i ~/.ssh/id_as_ed25519 as@"$2"	"echo "$nombre ha sido creado" "
		ssh -n -i ~/.ssh/id_as_ed25519 as@"$2" "echo "$usuario":"$contra" | sudo chpasswd "
		else
			echo "El usuario $usuario ya existe"
		fi

	done < "$1"
  IFS=$auxIFS
}



borrar(){
    IFS=','
    while read user ignore
    do
		if  id -u "$user" >/dev/null 2>&1
		then
			ssh -n -i ~/.ssh/id_as_ed25519 as@"$2" "sudo usermod -L "$user"" #Bloquea la cuenta del usuario
			ssh -n -i ~/.ssh/id_as_ed25519 as@"$2" "tar cf /extra/backup/"$user".tar /home/"$user"" &>/dev/null  #hace backup
			if [ $? ]# si lo ha hecho bien borra
			then
		    		ssh -n -i ~/.ssh/id_as_ed25519 as@"$2" "sudo userdel -r -f \"$user\"" &>/dev/null && echo "$user borrado con exito"
			fi
		fi
    done < "$1"
    IFS=$auxIFS
}

auxIFS=$IFS
#Main


if [ $# -ne 3 ] #Parametros correctos
then
    echo "Numero incorrecto de parametros"
    exit 1
fi

if [ "$1" != "-a" -a "$1" != "-s" ] #Parametros correctos
then
    echo "Opcion invalida"
    exit 1
fi

while read ip
do
	if ping -q -c1 "$ip" >/dev/null #Funciona el ping
	then
		if [ "$1" == "-s" ] #borrar
		then
			mkdir -p /extra/backup/
			borrar "$2" "$ip"
		else #anyadir
			anyadir "$2" "$ip"
		fi
	else
		echo "$ip no es accesible"
	fi
done < "$3"
