#!/bin/bash
DB=iot
DBPWD="1234"


# COMUNICACAO SERIAL
old=""
uid="111"
while true; do
	# CHECK FIRST 4 USB PORTS
	if [ -e /dev/ttyUSB0 ] || [ -e /dev/ttyUSB1 ] ||\
	   [ -e /dev/ttyUSB2 ] || [ -e /dev/ttyUSB3 ]; then
		echo AGUARDANDO
		# GET PORT VALUE
		chmod 666 /dev/ttyUSB*
		read line < /dev/ttyUSB*  
		echo ENTROU
		echo line = $line
		echo old = $old	
	#	echo comparando..


	#	echo comparando..

		# NOISE FILTER
		# if [ ! "$line" = "$old" ]; then  
			uid=$(echo $line | grep -v "Aproxime\| \|:\|/\|?\|#\|@\|!\|$\|&\|'\|)\|*\|+\|,\|;\|=\|%\|[\|]")
			echo uid = $uid	

			# mysql $DB
			if [ ! "$uid" = "" ]; then
				/opt/lampp/bin/mysql -s -u $DB -p$DBPWD -e "insert into $DB.presenca (timestamp,uid) values (now(),\"$uid\")"
				# UTC -3
				# /opt/lampp/bin/mysql -s -u $DB -p$DBPWD -e "insert into $DB.presenca (timestamp,uid) values (now() - INTERVAL 3 HOUR,\"$uid\")"
			fi
			
		# fi
		# CLEAN BUFFER
		echo ZERANDO BUFFER
		line=""
	else echo USB NAO ENCONTRADA
	fi # END IF -F /DEV/TTYUSB0123
	
	sleep 0.5
	
done
