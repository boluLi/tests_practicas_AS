#!/bin/bash
#718197, Li Yuan, Bolu, [M], [3], [B]
if [ $# -ne 1 ]
then
	echo "Parametros insuficientes"
	exit 1
fi
ip=$1
if ping -q -c1 "$ip"  >/dev/null
then
	ssh -i ~/.ssh/id_as_ed25519 as@"$ip" "sudo sfdisk -s;echo -e "\n";sudo sfdisk -l;echo -e "\n";df -hT"
else
	echo "$ip no es accesible"
fi
fi
