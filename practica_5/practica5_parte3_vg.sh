#!/bin/bash
#718197, Li Yuan, Bolu, [M], [3], [B]
if [ $# -lt 2 ]
then
	echo "Error de parametros"
	exit 1
fi
nombreGrupoVolumen=$1
shift #Desplazamos un parametro hacia la izquierda ya que es el nombre del grupo volumen 
for i in $@
do
	sudo umount "$i"
	sudo vgextend "$nombreGrupoVolumen" "$i"
done
