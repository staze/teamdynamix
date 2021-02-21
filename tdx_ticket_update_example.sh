#!/bin/bash
#Requires jq binary be in active path

#TDX API Variables
TDXUsername=''
TDXPassword=''
TDXAuthUri='https://university.teamdynamix.com/TDWebApi/api/auth/'
TEXT="Test ticket update"
TDX_TICKET_ID="11111111"

if [ "$TDX_TICKET_ID" ]; then
	#Get TDX Auth token
	token=$(curl -s -d "username=$TDXUsername&password=$TDXPassword" $TDXAuthUri)
	echo "Status: Updating ticket $TDX_TICKET_ID..."
	TICKET_URI=$(echo "https://university.teamdynamix.com/TDWebApi/api/430/tickets/$TDX_TICKET_ID/feed")
	TICKET_DESC=$(printf "$TEXT")
	TICKET_UPDATE=$(jq -r -n --arg COMM "$TICKET_DESC" '{NewStatusID: "0", isPrivate: "TRUE", comments: $COMM}')
	echo $TICKET_UPDATE
	curl -s -H 'Content-Type: application/json' -H "Authorization: Bearer ${token}" -d "$TICKET_UPDATE" $TICKET_URI
fi