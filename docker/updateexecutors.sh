#! /bin/bash -e

curl -s ${JENKINS_URL}/jnlpJars/jenkins-cli.jar -o ${JENKINS_HOME}/jenkins-cli.jar
sed -e "s/<numExecutors>0/<numExecutors>10/" ${JENKINS_HOME}/config.xml > ${JENKINS_HOME}/config_1.xml
mv ${JENKINS_HOME}/config_1.xml ${JENKINS_HOME}/config.xml
java -jar  ${JENKINS_CLI} -s ${JENKINS_URL} -auth ${JENKINS_USER}:${JENKINS_PASS} reload-configuration
