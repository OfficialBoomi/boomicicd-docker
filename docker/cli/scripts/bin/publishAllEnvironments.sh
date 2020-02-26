#!/bin/bash

source bin/common.sh
# get atom id of the by atom name
# mandatory arguments
URL=$baseURL/Environment/query
JSON_FILE=json/queryEnvironmentAny.json

callAPI
mapfile -t ids < <(jq -r .result[].id "${WORKSPACE}/out.json")
mapfile -t classifications < <(jq -r .result[].classification "${WORKSPACE}/out.json")
mapfile -t names < <(jq -r .result[].name "${WORKSPACE}/out.json")
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

printf "%s\n" "<h2>List of All Environments</h2>"

printf "%s\n" "<table>"
printf "%s\n" "<tr>"
printf "%s\n" "<th>ID</th>"
printf "%s\n" "<th>Classification</th>"
printf "%s\n" "<th>Name</th>"
printf "%s\n\n" "</tr>"
i=0;
while [ "$i" -lt "${#ids[@]}" ]; do printf  "%s\n%s\n%s\n\n"  "<tr><th>${ids[$i]}</th>" "<th>${classifications[$i]}</th>" "<th>${names[$i]}</th></tr>"; i=$(( $i + 1 )); done
printf "%s\n" "</table>"
printf "%s\n" "</body>"
printf "%s\n" "</html>"

clean
