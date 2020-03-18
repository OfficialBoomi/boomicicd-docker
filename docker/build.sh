#!/bin/bash
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

curdir=`pwd`
echo ${curdir}
cp -R ../../boomicicd-jenkinsjobs/jenkins_jobs jenkins_jobs
cp -R ../../boomicicd-cli/cli cli
cd ${curdir}/jenkins_jobs/jobs
find . -type d -name workspace -exec rm -rf "{}" ";" 2>&1 > /dev/null
cd ${curdir}
echo `pwd`
cp -R ../../boomicicd-cli/cli cli
docker build -t ${name}:${tag} .
rm -rf cli
rm -rf jenkins_jobs
