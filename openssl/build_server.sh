#! /bin/bash

set -euxab

{
    cd $(dirname -- "$0")
    if ! [[ -f ca-key.pem ]]
    then

        # creating a new certificate request for server with key ...
        openssl req -new -nodes -keyout server.key -out server.csr -config ./openssl.conf

        # signing certificate request ...
        openssl x509 -req -days 365 -in server.csr -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server.crt

    fi

    if ! [[ -f dh2048.pem ]]
    then
        # generating dhparam file ...
        openssl dhparam -out dh2048.pem 2048
    fi


    if ! [[ -f ta.key ]]
    then
        # generating ta.key file ...
        openvpn --genkey secret ta.key
    fi
}
