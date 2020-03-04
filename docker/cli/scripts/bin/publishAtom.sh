#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
JSON_FILE=json/queryAny.json
URL=$baseURL/Atom/query

inputs "$@"

if [ "$?" -gt "0" ]
then
        return 255;
fi

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

printf "%s\n" "<h2>List of Atoms</h2>"
printf "%s\n" "<table>"
printf "%s\n" "<tr>"
printf "%s\n" "<th>#</th>"
printf "%s\n" "<th>Atom Id</th>"
printf "%s\n" "<th>Atom Name</th>"
printf "%s\n" "<th>Environment Name</th>"
printf "%s\n" "<th>Status</th>"
printf "%s\n\n" "</tr>"


k=0;
h=0;
mapfile -t ids < <(jq -r .result[].id "${WORKSPACE}/out.json")
mapfile -t names < <(jq -r .result[].name "${WORKSPACE}/out.json")
mapfile -t statuss < <(jq -r .result[].status "${WORKSPACE}/out.json")

while [ "$k" -lt "${#ids[@]}" ];
do
      h=$(( $h + 1 ));
			atomId=${ids[$k]}
      source bin/queryAtomAttachment.sh atomId="${atomId}" envId="%%"
      env=""
		  if [ null != "${envId}" ]
			then
				URL=$baseURL/Environment/${envId}
				env=`curl -s -X GET -u $authToken -H "${h1}" -H "${h2}" $URL | jq -r .name`
			fi	
			printf  "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n"  "<tr><th>${h}</th>" "<th>${atomId}</th>" "<th>${names[$k]}</th>" "<th>${env}</th>" "<th>${statuss[$k]}</th></tr>";
      k=$(( $k + 1 ));
done

queryToken=`jq -r .queryToken "$WORKSPACE/out.json"`
while [ null != "${queryToken}" ]
do
    URL=$baseURL/Process/queryMore
    curl -s -X POST -u $authToken -H "${h1}" -H "${h2}" $URL -d$queryToken > "${WORKSPACE}"/out.json
    k=0;
		mapfile -t ids < <(jq -r .result[].id "${WORKSPACE}/out.json")
		mapfile -t names < <(jq -r .result[].name "${WORKSPACE}/out.json")
		mapfile -t statuss < <(jq -r .result[].status "${WORKSPACE}/out.json")

		while [ "$k" -lt "${#ids[@]}" ];
		do
				h=$(( $h + 1 ));
				atomId=${ids[$k]}
				source bin/queryAtomAttachment.sh atomId="${atomId}" envId="%%"
				env=""
				if [ null != "${envId}" ]
				then
					URL=$baseURL/Environment/${envId}
					env=`curl -s -X GET -u $authToken -H "${h1}" -H "${h2}" $URL | jq -r .name`
				fi	
				printf  "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n"  "<tr><th>${h}</th>" "<th>${atomId}</th>" "<th>${names[$k]}</th>" "<th>${env}</th>" "<th>${statuss[$k]}</th></tr>";
				k=$(( $k + 1 ));
		done
		
    queryToken=`jq -r .queryToken "$WORKSPACE/out.json"`
done

printf "%s\n" "</table>"
printf "%s\n" "</body>"
printf "%s\n" "</html>"

 
clean
