#!/bin/bash
DB=iot
DBPWD="1234"

PROFTIME=6
ALUTIME=2

URLONTHING1="http://192.168.15.7/26/on"
URLOFFTHING1="http://192.168.15.7/26/off"


# READ DB
PROFCOUNT=$(mysql -u $DB -b $DB -p$DBPWD -e "select count(timeStamp) from presenca where uid in (select uid from cartao where perf = 'professor') and timeStamp >= NOW() - INTERVAL $PROFTIME MINUTE ")

ALUCOUNT=$(mysql -u $DB -b $DB -p$DBPWD -e "select count(timeStamp) from presenca where uid in (select uid from cartao where perf = 'aluno') and timeStamp >= NOW() - INTERVAL $ALUTIME MINUTE ")


# TURN OFF CASE NO ACTIVE PERSONS
if [ "$PROFCOUNT" -eq "0" ] && [ "$ALUCOUNT" -eq "0" ] ; then 
	echo "PROFCOUNT=$PROFCOUNT ALUCOUNT=$ALUCOUNT"
	echo "CALL HTTP OFF"
	curl $URLOFFTHING1 > /dev/null
	
# TURN ON CASE
else 
	echo "PROFCOUNT=$PROFCOUNT ALUCOUNT=$ALUCOUNT"
	echo "CALL HTTP ON"
	curl $URLONTHING1 > /dev/null
	
fi

