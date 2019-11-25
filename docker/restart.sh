#! /bin/bash -e
java -jar ${JENKINS_CLI} -s ${JENKINS_URL} -auth ${JENKINS_USER}:${JENKINS_PASS} safe-restart
