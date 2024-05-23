# /bin/bash

set -euxab
type jq ip

{

    cd $(dirname -- "$0")/..
    FIRST_IPV6=$(ip --json address | jq '.[] | select(.ifname | test("enp0s")) | .addr_info[1] | select( .family == "inet6" ) | .local')
    cat <<EOF
client

# OpenVPN traffic on 443/tcp is almost never blocked because, since OpenVPN
# uses SSL, it's very hard to distinguish this traffic from "real" HTTPS
# traffic.
#
remote $FIRST_IPV6 1294 udp6

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
$(cat openssl/ca-cert.pem)
</ca>
# Client cert
<cert>
$(cat openssl/client-cert.pem)
</cert>
# Client private key 
<key>
$(cat openssl/client-key.pem)
</key>

# PSK and direction of TLS channel authentication
<tls-auth>
$(cat openssl/ta.key)
</tls-auth>
key-direction 1

EOF

}