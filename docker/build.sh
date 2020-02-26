#!/bin/bash
tag=$1
if [[ null == "${tag}" ]]
then
  echo "No tag for build"
  return 255
fi
dir=$(pwd)
cd ${dir}/jenkins_jobs/jobs
find . -type d -name workspace -exec rm -rf "{}" ";" 2>&1 > /dev/null
cd ${dir}
docker build -t integrationguy/boomicicd:${tag} .

