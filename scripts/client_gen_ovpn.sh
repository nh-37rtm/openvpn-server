# /bin/bash

set -euxab


cd $(dirname -- "$0")/../openssl

prerequisites()
{
    type test cat jq ip
    for pr in ca-cert.pem client-cert.pem client-key.pem ta.key
    do
        test -e  "$pr"
    done
    
}

prerequisites >/dev/null

{

    FIRST_IPV6=$(ip --json address | jq '.[] | select(.ifname | test("ens|eth")) | .addr_info[1] | select( .family == "inet6" ) | .local')
    cat <<EOF
client

# OpenVPN traffic on 443/tcp is almost never blocked because, since OpenVPN
# uses SSL, it's very hard to distinguish this traffic from "real" HTTPS
# traffic.
#
remote $FIRST_IPV6 1194 udp6

# If the server doesn't answer after 5 seconds, try the next server.
server-poll-timeout 5

allow-compression no
# tun has lower traffic overhead than tap.
dev tun

# Allocate a dynamic port for returning packets.
nobind
# Make sure we're speaking to the server and not another client
# Trying to man-in-the-middle us.
remote-cert-tls server
# TLS versions <1.2 are vulnerable to many attacks.
tls-version-min 1.2
# Prefer the strong AES-256-GCM cipher. We can't use ncp-ciphers here because
# that is not supported by openvpn versions <2.4.
cipher AES-256-GCM
# Use SHA256 for auth since the default SHA1 is insecure. This setting will
# be ignored when GCM is used (which uses SHA384)
auth SHA256

verb 3
mute 20
mute-replay-warnings

# Certificate Authority cert
<ca>
$(cat ca-cert.pem)
</ca>
# Client cert
<cert>
$(cat client-cert.pem)
</cert>
# Client private key 
<key>
$(cat client-key.pem)
</key>

# PSK and direction of TLS channel authentication
<tls-auth>
$(cat ta.key)
</tls-auth>
key-direction 1

EOF

}