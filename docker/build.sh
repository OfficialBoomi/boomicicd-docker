#!/bin/bash
# The docker image copies the files from jenkins, cli and sonarqube repos to create the image
name=$1
tag=$2

if [[ null == "${name}" ]]
then
  echo "No name for the image"
  return 255
fi

if [[ null == "${tag}" ]]
then
  echo "No tag for the image"
  return 255
fi
rm -rf jenkins_jobs cli sonarqube

curdir=`pwd`
cp -R ../../boomicicd-jenkinsjobs/jenkins_jobs jenkins_jobs
cp -R ../../boomicicd-cli/cli cli
cd ${curdir}/jenkins_jobs/jobs
find . -type d -name workspace -exec rm -rf "{}" ";" 2>&1 > /dev/null
cd ${curdir}
mkdir -p sonarqube
unzip -q ../../boomicicd-cli/sonarqube/sonar*.zip -d sonarqube
chmod u+x sonarqube/sonar*/bin/*
cp -R ../../boomicicd-cli/cli cli
rm -f cli/scripts/*.json cli/scripts/*.html cli/scripts/*.xml
docker build -t ${name}:${tag} .
rm -rf cli
rm -rf jenkins_jobs
rm -rf sonarqube
