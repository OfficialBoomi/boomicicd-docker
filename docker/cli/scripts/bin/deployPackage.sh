#!/bin/bash
source bin/common.sh

# get atom id of the by atom name
# mandatory arguments
ARGUMENTS=(env processName packageVersion createdBy notes listenerStatus)
inputs "$@"
if [ "$?" -gt "0" ]
then
        return 255;
fi
deployNotes=$notes;
source bin/queryProcess.sh processName="$processName"
source bin/createPackagedComponent.sh componentId=$componentId componentType="process" createdBy="$createdBy" packageVersion=$packageVersion notes="$notes"
source bin/queryEnvironment.sh env="$env" classification="*"
source bin/createDeployedPackage.sh envId=${envId} listenerStatus="${listenerStatus}" packageId=$packageId notes="$deployNotes"

clean
