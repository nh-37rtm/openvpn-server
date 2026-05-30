set -eux

. $VIRTUAL_ENV/bin/activate

for proto in tcp udp; 
do
    SERVER_PROTO=$proto jte -t ./conf/templates/openvpn_server.conf.j2 > \
        /opt/openvpn/conf/openvpn_${proto}.conf
done

# exec openvpn $@