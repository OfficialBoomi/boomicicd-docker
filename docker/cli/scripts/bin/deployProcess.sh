#!/bin/bash
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(processId envId componentType notes)
JSON_FILE=json/deployProcess.json
URL=$baseURL/Deployment
id=id
exportVariable=processDeploymentId

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

createJSON
 
callAPI
 
clean
