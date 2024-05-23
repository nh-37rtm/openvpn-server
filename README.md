
docker run -it -v /dev/net/tun:/dev/net/tun --network host --cap-add NET_ADMIN openvpn

openvpn --cd /etc/openvpn/server/ --config /etc/openvpn/server/openvpn.conf