#!/bin/bash
DB=iot
DBPWD="1234"


URLONTHING1="http://192.168.15.7/26/on"



# COMUNICACAO SERIAL
old=""
uid="111"
while true; do
	# CHECK FIRST 4 SERIAL PORTS
	if [ -e /dev/ttyACM0 ] || [ -e /dev/ttyACM1 ] ||\
	   [ -e /dev/ttyACM2 ] || [ -e /dev/ttyACM3 ]; then
		echo AGUARDANDO
		# GET PORT VALUE
		chmod 666 /dev/ttyACM*
		read line < /dev/ttyACM*  
		echo ENTROU
		echo line = $line
		#	echo comparando..


	#	echo comparando..

		# NOISE FILTER
		# if [ ! "$line" = "$old" ]; then  
			# uid=$(echo $line | grep -v "Aproxime\| \|:\|/\|?\|#\|@\|!\|$\|&\|'\|)\|*\|+\|,\|;\|=\|%\|[\|]")
		if echo $line | grep -oE "[0-9a-fA-F]{8}" > /dev/null  ; then
			# && [ "${#line}" -eq 8 ]
			echo FORMATO CERTO
			if [ ! "$uid" = "$line" ]; then
				uid=$line
				echo uid = $uid	
			# mysql $DB
			# if [ ! "$uid" = "" ]; then
				DATE=$(date "+%Y-%m-%d %H:%M:%S")
			    # /opt/lampp/bin/mysql -s -u $DB -p$DBPWD -e "insert into $DB.presenca (timestamp,uid) values (\"$DATE\",\"$uid\")"
				mysql -u $DB -b $DB -p$DBPWD -e "insert into presenca (timeStamp,uid) values (\"$DATE\",\"$uid\")"
				
				# TURN ON CASE
				echo "CALL HTTP ON"
				curl $URLONTHING1 > /dev/null

				#/opt/lampp/bin/mysql -s -u $DB -p$DBPWD -e "insert into $DB.presenca (timestamp,uid) values (\"$(date "+%Y-%m-%d %H:%M:%S")\",\"$uid\")"
				# UTC -3
				# /opt/lampp/bin/mysql -s -u $DB -p$DBPWD -e "insert into $DB.presenca (timestamp,uid) values (now() - INTERVAL 3 HOUR,\"$uid\")"
			fi
			
		fi
		# CLEAN BUFFER
		echo ZERANDO BUFFER
		line=""
	else echo SERIAL NAO ENCONTRADA
	fi # END IF -F /DEV/ttyACM0123
	
	sleep 0.5
	
done
