#! /bin/bash -e
/sbin/tini -- /usr/local/bin/jenkins.sh
java -jar ${JENKINS_CLI} -s ${JENKINS_URL} -auth ${JENKINS_USER}:${JENKINS_PASS} safe-restart
sed -e "s/GIT_CONFIG_NAME/${GIT_CONFIG_NAME}/" -e "s/GIT_CONFIG_EMAIL/${GIT_CONFIG_EMAIL}/"  ${JENKINS_HOME}/hudson.plugins.git.GitSCM.xml_1 > ${JENKINS_HOME}/hudson.plugins.git.GitSCM.xml
git config --global user.email ${GIT_CONFIG_EMAIL}
git config --global user.name  ${GIT_CONFIG_USER}
