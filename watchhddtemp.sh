#!/bin/bash

ALERT_LEVEL=50
SEND_ALERT=0

MESSAGE="Hard Drive Temperature Report at `date`: "
MESSAGE+=$'\n\n'

SERVER="aspmx.l.google.com"
FROM="From address"
TO="Email Address to Send"
CHARSET="utf-8"
SUBJ="Hard Drive Temperature Report at `date`"

TEMP=""


for DEV in /dev/sd*
do
	STR_CONCAT=`/usr/sbin/hddtemp $DEV`
	#TEMP= $(hddtemp $DEV | awk '{print $NF}' | awk -F '°' '{ print $1}')
	if [[ $(/usr/sbin/hddtemp $DEV | awk '{print $NF}' | awk -F '°' '{ print $1}') -ge $ALERT_LEVEL ]]; then
		SEND_ALERT=1
	fi
	MESSAGE+=$STR_CONCAT
	MESSAGE+=$'\n'
done

#echo "$MESSAGE" > temp.txt

if [ $SEND_ALERT -ge 1 ]; then
	SUBJ="ALERT: HARD DRIVE TEMPERATURE REPORT AT `date`"
	sendemail -f $FROM -t $TO -s $SERVER -v -o message-charset=$CHATSET -u $SUBJ -m "$MESSAGE"
else
	sendemail -f $FROM -t $TO -s $SERVER -v -o message-charset=$CHATSET -u $SUBJ -m "$MESSAGE"
fi
