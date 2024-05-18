#!/bin/bash
#718197, Li Yuan, Bolu, [M], [3], [B]

crear(){
		sudo lvcreate "$nombreGrupoVolumen" -L "$tamanyo" --name "$nombreVolumenLogico" </dev/null
		sudo mkfs -t "$tipoSistemaFicheros" /dev/"$nombreGrupoVolumen"/"$nombreVolumenLogico" </dev/null
		echo "echo "/dev/mapper/"$nombreGrupoVolumen"-"$nombreVolumenLogico" $directorioMontaje $tipoSistemaFicheros rw,errors=remount-ro 0 0" >> /etc/fstab" | sudo bash -s </dev/null

}

#Main
if [ $# -gt 1 ]
then
	echo "Error de parametros. Uso: ./practica_parte3 "
	exit 85
fi
AuxIFS=$IFS
IFS=','
while read nombreGrupoVolumen nombreVolumenLogico tamanyo tipoSistemaFicheros directorioMontaje
do
	if [ $(sudo lvdisplay | grep -c "/dev/"$nombreGrupoVolumen"/"$nombreVolumenLogico"") -gt 0 ]
	then
		sudo lvextend -L +"$tamanyo" /dev/"$nombreGrupoVolumen"/"$nombreVolumenLogico" </dev/null #extender volumen logico
		echo "Extendido correctamente"
	else
		crear
		echo "Creado correctamente"
	fi
done
IFS="$AuxIFS"
