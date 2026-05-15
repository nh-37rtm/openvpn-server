#! /bin/bash

set -eux

DIR_NAME=$(dirname -- "$0")

cd ${DIR_NAME}/..
# creation de l'archive tar avec la conf
tar cf conf.tar --ignore-failed-read --dereference ./conf
docker-compose up --build




