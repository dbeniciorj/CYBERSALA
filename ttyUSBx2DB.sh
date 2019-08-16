#!/bin/bash
DB=iot
DBPWD="1234"


# COMUNICACAO SERIAL
chmod 666 /dev/ttyUSB*
old=""
uid="111"
while true; do
	read -r line < /dev/ttyUSB*  
	echo line = $line
	echo old = $old	
#	echo comparando..

	echo uid = $uid
#	echo comparando..


	if [ ! "$line" = "$old" ]; then  
		uid=$(echo $line | grep -v "Aproxime\|:\|/\|?\|#\|@\|!\|$\|&\|'\|)\|*\|+\|,\|;\|=\|%\|[\|]")
		echo $uid
	    
		# mysql $DB
		/opt/lampp/bin/mysql -s -u $DB -p$DBPWD -e "insert into $DB.presenca (timestamp,uid) values (now() - INTERVAL 3 HOUR,\"$uid\")"
		
		# CONTROL VAR.
		old=$(echo $uid)

	fi	
	sleep 0.2
	
done
