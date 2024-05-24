
# openvpn helper server and scripts


## generate a new server certificate 
bash ./scripts/build_server.sh

## generate a new server certificate (overwrite old certificate !)
bash ./scripts/build_client.sh

## build/start the server
docker-compose up

## acess openvpn management interface 

user# apt install netcat-openbsd
user# nc -U ./server/management.sock