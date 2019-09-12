#!/usr/bin/env bash

echo -e "This script will build JDK11 TCZ for Tiny Core:10.0-x86_64\n"
echo -e "Note: Please download the OpenJDK tar.gz file from https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases\n"

SOURCE=$(ls *jdk*linux*11*.tar.gz | tail -1)

if [ ! -n "$SOURCE" ] 
then
  echo "*jdk*linux*11*.tar.gz not found! exiting ..."
  exit 1
fi
docker build -t jdk11-tcz .
docker run --volume "$(pwd):/opt/build" --cidfile=containerid  -u root jdk11-tcz sh -c "/opt/build/build-jdk11tcz.sh"

CONTAINER_ID=$(cat containerid)
docker cp ${CONTAINER_ID}:/tmp/jdk11.tcz ./
docker rm -f ${CONTAINER_ID}
rm containerid
