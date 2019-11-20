#!/bin/bash

# Capture user inputs
function inputs {
     for ARGUMENT in "$@"
     do
       KEY=$(echo $ARGUMENT | cut -f1 -d=)
       VALUE=$(echo $ARGUMENT | cut -f2 -d=)
      	for i in "${ARGUMENTS[@]}"
      	do
					# remove all old values of the ARGUMENTS
        	case "$KEY" in
              $i)  unset ${KEY}; export eval $KEY="${VALUE}" ;;
              *)
        	esac
      done
 
   if [ $KEY = "help" ]
   then
     usage
     return 255; 
   fi
  done
 
   # Check inputs
   for i in "${ARGUMENTS[@]}"
   do
    if [ -z "${!i}" ]
    then
      echo "Missing mandatory field:  ${i}"
      usage
      return 255;
    fi
   done
  }
 
# The help function
function usage {
   #echo "Usage"
    var=""
    for ARGUMENT in "${ARGUMENTS[@]}"
    do
     var=$var"${ARGUMENT}=\${$ARGUMENT} "
    done
   echo "source ${BASH_SOURCE[2]} $var"
}
 
# The help function
function printArgs {
   echo "ARGUMENTS"
    for ARGUMENT in "${ARGUMENTS[@]}"
    do
     echo "${ARGUMENT}=${!ARGUMENT}"
    done
}


# Create JSON file with inputs from template
function createJSON {
	# Iteratively create a query string to replace the variables in the JSON File
 		var="sed "
 		for i in "${ARGUMENTS[@]}"
  		do var=$var" -e \"s/\\\${${i}}/${!i}/\" ";
 		done
 	var=$var" $JSON_FILE > "${WORKSPACE}"/tmp.json"
 	eval $var
}

# unset all variables and tmp files
function clean {
	 for i in "${ARGUMENTS[@]}"
		do
			unset $i
	  done
	 unset JSON_FILE ARGUMENTS id URL var ARGUMENT i exportVariable
	 #rm -f "${WORKSPACE}"/*.json
}

# call platform API
function callAPI {
 
 #echo "curl -s -X POST -u $authToken -H \"${h1}\" -H \"${h2}\" $URL -d@tmp.json > out.json"
 curl -s -X POST -u $authToken -H "${h1}" -H "${h2}" $URL -d@$"{WORKSPACE}"/tmp.json > "${WORKSPACE}"/out.json
 if [ ! -z "$exportVariable" ]
 then
  	export ${exportVariable}=`jq -r .$id "${WORKSPACE}"/out.json`
 fi
}
