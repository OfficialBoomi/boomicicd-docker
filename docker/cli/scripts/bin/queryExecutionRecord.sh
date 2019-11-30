#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(from to processName atomName)
JSON_FILE=json/queryExecutionRecord.json
URL=$baseURL/ExecutionRecord/query
id=result[0].executionId
exportVariable=executionId
now=`date -u +"%Y-%m-%d"T%H:%M:%SZ`
lag=`date -u +"%Y-%m-%d"T%H:%M:%SZ --date '-2 min'`
if [ -z "${to}" ]
then
       to=$now
fi

if [ -z "${from}" ]
then
       from=$lag
fi

inputs "$@"


if [ "$?" -gt "0" ]
then
        return 255;
fi

createJSON
 
callAPI

extract result[0].status status
extract result[0].message message
 
clean
