#!/bin/bash
source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(env)
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi
source bin/queryEnvironment.sh env=${env} classification="*"

ARGUMENTS=(envId)
URL=$baseURL/DeployedPackage/query
JSON_FILE=json/queryDeployedPackageEnv.json
createJSON
callAPI
printf "%s\n" "<html>"
printf "%s\n" "<head>"
printf "%s\n" "<style>"
printf "%s\n" "table {"
printf "\t%s\n" "font-family: arial, sans-serif;"
printf "\t%s\n" "border-collapse: collapse;"
printf "\t%s\n" "width: 100%;"
printf "%s\n" "}"

printf "%s\n" "td, th {"
printf "\t%s\n" "border: 1px solid #dddddd;"
printf "\t%s\n" "text-align: left;"
printf "\t%s\n" "padding: 8px;"
printf "%s\n" "}"

printf "%s\n" "tr:nth-child(even) {"
printf "\t%s\n" "background-color: #dddddd;"
printf "%s\n" "}"
printf "%s\n" "</style>"
printf "%s\n" "</head>"
printf "%s\n" "<body>"
 
printf "%s\n" "<h2>List of Deployed Packages</h2>"
 
printf "%s\n" "<table>"
printf "%s\n" "<tr>"
printf "%s\n" "<th>#</th>"
printf "%s\n" "<th>Component</th>"
printf "%s\n" "<th>Package Version</th>"
printf "%s\n" "<th>Environment</th>"
printf "%s\n" "<th>Component Type</th>"
printf "%s\n" "<th>Deployed Date</th>"
printf "%s\n" "<th>Deployed By</th>"
printf "%s\n" "<th>Notes </th>"
printf "%s\n\n" "</tr>"


i=0;
h=0;
mapfile -t ids < <(jq -r .result[].deploymentId "${WORKSPACE}/out.json")
mapfile -t cids < <(jq -r .result[].componentId "${WORKSPACE}/out.json")
mapfile -t pvs < <(jq -r .result[].packageVersion "${WORKSPACE}/out.json")
mapfile -t eids < <(jq -r .result[].environmentId "${WORKSPACE}/out.json")
mapfile -t ctypes < <(jq -r .result[].componentType "${WORKSPACE}/out.json")
mapfile -t ddates < <(jq -r .result[].deployedDate "${WORKSPACE}/out.json")
mapfile -t dbys < <(jq -r .result[].deployedBy "${WORKSPACE}/out.json")
mapfile -t notes < <(jq -r .result[].notes "${WORKSPACE}/out.json")

while [ "$i" -lt "${#ids[@]}" ]; 
do 
		h=$(( $h + 1 ));
		URL=$baseURL/Process/${cids[$i]}
		name=`curl -s -X GET -u $authToken -H "${h1}" -H "${h2}" $URL | jq -r .name`
		
		URL=$baseURL/Environment/${eids[$i]}
		env=`curl -s -X GET -u $authToken -H "${h1}" -H "${h2}" $URL | jq -r .name`

    printf  "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n"  "<tr><th>${h}</th>" "<th>${name}</th>" "<th>${pvs[$i]}</th>" "<th>${env}</th>" "<th>${ctypes[$i]}</th>" "<th>${ddates[$i]}</th>" "<th>${dbys[$i]}</th>" "<th>${notes[$i]}</th></tr>";	
		i=$(( $i + 1 )); 
done

queryToken=`jq -r .queryToken "$WORKSPACE/out.json"`
while [ null != "${queryToken}" ] 
do
	URL=$baseURL/Process/queryMore
	curl -s -X POST -u $authToken -H "${h1}" -H "${h2}" $URL -d$queryToken > "${WORKSPACE}"/out.json
	i=0;
	mapfile -t ids < <(jq -r .result[].deploymentId "${WORKSPACE}/out.json")
	mapfile -t cids < <(jq -r .result[].componentId "${WORKSPACE}/out.json")
	mapfile -t pvs < <(jq -r .result[].packageVersion "${WORKSPACE}/out.json")
	mapfile -t eids < <(jq -r .result[].environmentId "${WORKSPACE}/out.json")
	mapfile -t ctypes < <(jq -r .result[].componentType "${WORKSPACE}/out.json")
	mapfile -t ddates < <(jq -r .result[].deployedDate "${WORKSPACE}/out.json")
	mapfile -t dbys < <(jq -r .result[].deployedBy "${WORKSPACE}/out.json")
	mapfile -t notes < <(jq -r .result[].notes "${WORKSPACE}/out.json")

	while [ "$i" -lt "${#ids[@]}" ]; 
	do 
		h=$(( $h + 1 ));
		URL=$baseURL/Process/${cids[$i]}
		name=`curl -s -X GET -u $authToken -H "${h1}" -H "${h2}" $URL | jq -r .name`
		
		URL=$baseURL/Environment/${eids[$i]}
		env=`curl -s -X GET -u $authToken -H "${h1}" -H "${h2}" $URL | jq -r .name`

    printf  "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n"  "<tr><th>${h}</th>" "<th>${name}</th>" "<th>${pvs[$i]}</th>" "<th>${env}</th>" "<th>${ctypes[$i]}</th>" "<th>${ddates[$i]}</th>" "<th>${dbys[$i]}</th>" "<th>${notes[$i]}</th></tr>";	
		i=$(( $i + 1 )); 
	done
	queryToken=`jq -r .queryToken "$WORKSPACE/out.json"`
done

printf "%s\n" "</table>"
printf "%s\n" "</body>"
printf "%s\n" "</html>"

clean
