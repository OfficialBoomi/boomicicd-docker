#! /bin/bash -e
# sed -e "s/GIT_CONFIG_NAME/${GIT_CONFIG_NAME}/" -e "s/GIT_CONFIG_EMAIL/${GIT_CONFIG_EMAIL}/"  ${JENKINS_HOME}/hudson.plugins.git.GitSCM.xml_1 > ${JENKINS_HOME}/hudson.plugins.git.GitSCM.xml
# git config --global user.email ${GIT_CONFIG_EMAIL}
# git config --global user.name  ${GIT_CONFIG_USER}

SECRET=`cat ${REF}/secret`
if [[ "${SECRET}" != "${KEY}" ]]
then
	exit 255
else
	/sbin/tini -- /usr/local/bin/jenkins.sh
fi
