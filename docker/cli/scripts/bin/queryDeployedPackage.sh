#!/bin/bash
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(envId packageId)
JSON_FILE=json/queryDeployedPackage.json
URL=$baseURL/DeployedPackage/query
id=result[0].deploymentId
exportVariable=deploymentId

inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi

createJSON
 
callAPI
 
clean
