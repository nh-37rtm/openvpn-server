#! /bin/bash

set -eux

DIR_NAME=$(dirname -- "$0")

cd ${DIR_NAME}/..



# screen -S openvpn_server -X quit
# screen -dms openvpn_server -t 

docker-compose up -d --build openssl

# creation de l'archive tar avec la conf
# tar cf - --ignore-failed-read --dereference ./conf | docker-compose exec -it openssl tar -C /opt/openvpn xf -

docker-compose exec openssl bash /opt/openvpn/scripts/generate_configuration.sh

docker-compose exec -it openssl CN=vpn bash ./scripts/build_server.sh
docker-compose exec -it openssl tar cf - /opt/openvpn/conf/ | docker-compose exec -it tar -C /opt/openvpn/ xf -

docker-compose up --build openvpn-server openvpn-tcp-server





