#!/bin/bash
#TDX API Variables
TDXUsername=''
TDXPassword=''
TDXAuthUri='https://university.teamdynamix.com/TDWebApi/api/auth/'

#Ticket ID to post the file to
TDX_TICKET_ID="11111111"

#File to upload to the ticket
FILE="/var/log/install.log"

#Grab the computer name
COMPUTER=$(/usr/sbin/scutil --get ComputerName)

#Grab the file name
FILENAME=$(echo "${FILE##*/}")

#Set Filename to Computer-Filename
FILENAME2="$COMPUTER-$FILENAME"

#gzip the file
FILEZIP="$FILENAME2.gz"
cp $FILE /tmp/$FILENAME2
gzip /tmp/$FILENAME2
cd /tmp

#Auth, then attach the file to the ticket
echo "Status: attaching file $FILEZIP to ticket $TDX_TICKET_ID..."
token=$(curl -s -d "username=$TDXUsername&password=$TDXPassword" $TDXAuthUri)
TICKET_URI=$(echo "https://university.teamdynamix.com/TDWebApi/api/430/tickets/$TDX_TICKET_ID/attachments")	    	
curl -s -H "Authorization: Bearer ${token}" -F upload_file=@$FILEZIP -X POST -vvv $TICKET_URI

#Clean up the file
rm $FILEZIP