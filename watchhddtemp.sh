#!/bin/sh

ALERT_LEVEL=50
SEND_ALERT=0

MESSAGE="Hard Drive Temperature Report at `date`: "
MESSAGE=$MESSAGE'\n\n'

SERVER="aspmx.l.google.com"
FROM="agni@dream-farmer.com"
TO="mrsakkaro@dream-farmer.com"
CHARSET="utf-8"
SUBJ="Hard Drive Temperature Report at `date`"


for DEV in /dev/sd*
do
	if [ $(hddtemp $DEV | awk '{print $NF}' | awk -F '°' '{ print $1}') -ge $ALERT_LEVEL ]; then
		SEND_ALERT=1
	fi
	STR_CONCAT=`hddtemp $DEV`
	MESSAGE=$MESSAGE$STR_CONCAT'\n'
	#hddtemp $DEV >> temp.txt
done

echo $MESSAGE

if [ $SEND_ALERT -ge 1 ]; then
	SUBJ="ALERT: HARD DRIVE TEMPERATURE REPORT AT `date`"
	sendemail -f $FROM -t $TO -s $SERVER -v -o message-charset=$CHATSET -u $SUBJ -m $MESSAGE
else
	sendemail -f $FROM -t $TO -s $SERVER -v -o message-charset=$CHATSET -u $SUBJ -m $MESSAGE
fi
