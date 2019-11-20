#!/bin/bash
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(atomId envId)
JSON_FILE=json/queryAtomAttachment.json
URL=$baseURL/EnvironmentAtomAttachment/query
id=result[0].id
exportVariable=atomAttachmentId

inputs "$@"
if [ "$?" -gt "0" ] 
then 
	return 255;
fi


createJSON
 
callAPI
 
clean
