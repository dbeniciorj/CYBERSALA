#!/bin/bash
BTMAC="3C:71:BF:10:73:42"
DB=iot
DBPWD="1234"

# COMUNICACAO BT
READ="$(gatttool -b $BTMAC --char-read --handle=0x0001 2>&1)"
if [[ $READ =~ "refused" ]]; then
    logger –t $0 "DEV $BTMAC nao encontrado."
else
    # ANSW="$(echo $READ | cut -d : -f2| xxd -r -p)"
    uid=$(gatttool -b $BTMAC --char-read --handle=0x0001 | cut -d : -f2 | sed -e 's/ //g')
    # echo UID= $uid
    # mysql $DB -u $DB -p$DBPWD -e "insert into tempLog values (now()- INTERVAL 3 HOUR,$TEMP,$HUMD)" 2>&1 | logger -t $0
    /opt/lampp/bin/mysql -s -u $DB -p$DBPWD -e "insert into $DB.presenca (timestamp,uid) values (now() - INTERVAL 3 HOUR,\"$uid\")"

fi


# TESTE
# hexchars="0123456789ABCDEF"
# uid=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e "s/\(..\)/:\1/g" )

# INSERE NO BANCO
# mysql -s -u $DB -p$DBPWD -e "insert into $DB.presenca (timestamp,uid) values (now() - INTERVAL 3 HOUR,\"00$uid\")" 
# mysql -s -u $DB -p$DBPWD -e "insert into $DB.presenca (timestamp,uid) values (now() - INTERVAL 3 HOUR,\"$uid\")" 
