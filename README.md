
# openvpn helper server and scripts


## generate a new server certificate 
bash ./scripts/build_server.sh

## generate a new server certificate (overwrite old certificate !)
## do not forget to change the CN field in openssl.conf
bash ./scripts/build_client.sh

## generate a ovpn client file

bash ./scripts/client_gen_ovpn.sh > ./client-configs/p52.ovpn

## build/start the server
docker-compose up

## configure uncomplicated firewall (ufw)

sudo ufw allow 1194/udp
sudo ufw allow in on tun0

## check sockets status

sudo ss -pnl

## acess openvpn management interface 

user# apt install netcat-openbsd
user# nc -U ./server/management.sock

## configure dnsmasq

sudo sh -c "cat > /etc/dnsmasq.d/37rtm.fr"
address=/vpn.37rtm.local/fd1d:cc55:893:1b4c::1
address=/vpn.37rtm.local/10.1.231.1
interface=tun0
