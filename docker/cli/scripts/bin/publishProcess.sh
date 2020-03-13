#!/bin/bash
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(processName)
JSON_FILE=json/searchProcess.json
URL=$baseURL/Process/query
append="%"
REPORT_TITLE="List of Processes"
REPORT_HEADERS=("#" "Process Id" "Process Name")
queryToken="new"
inputs "$@"

if [ "$?" -gt "0" ]
then
        return 255;
fi

processName="${append}${processName}${append}"
createJSON

printReportHead

h=0;
while [ null != "${queryToken}" ] 
do
	callAPI
	i=0;
  extractMap id ids	
  extractMap name names	
	while [ "$i" -lt "${#ids[@]}" ];
	 do 
		h=$(( $h + 1 ))
		printReportRow  "${h}" "${ids[$i]}" "${names[$i]}" 
		i=$(( $i + 1 )); 
  done
	extract queryToken queryToken 
	URL=$baseURL/Process/queryMore
done

printReportTail
clean
