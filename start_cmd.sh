#! /bin/bash

set -eux
docker run -it -v /dev/net/tun:/dev/net/tun --network host --cap-add NET_ADMIN openvpn