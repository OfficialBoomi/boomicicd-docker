# Jenkins Docker image of a Boomi CI/CD reference implemetation
This repository builds a jenkins:lts image with required Jenkins Jobs and CLI scripts to implement Boomi CI/CD. 

## Pre-requistes
Must have docker installed to build the image. 
Create a folder named boomicicd

```
$ BOOMICICD_HOME=/path/to/boomicicd
$ cd ${BOOMICICD_HOME}
$ git clone https://github.com/OfficialBoomi/boomicicd-cli
$ git clone https://github.com/OfficialBoomi/boomicicd-jenkinsjobs
$ git clone https://github.com/OfficialBoomi/boomicicd-docker
```

  
## Build

```
$ cd ${BOOMICICD_HOME}/boomicid-docker/docker
$ name="image_name" # E.g. boomicicd/jenkins 
$ tag="1.0"
$ ./build.sh $name $tag
$ docker tag $name:$tag $name:latest
```

## Run and configure
  To run and configure boomicicd jenkins goto https://hub.docker.com/repository/docker/boomicicd/jenkins

# Support
This image is not supported at this time. Please leave your comments at https://community.boomi.com/s/group/0F91W0000008r5WSAQ/devops-boomi
