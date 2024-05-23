#! /bin/bash

set -euxab

{
    cd $(dirname -- "$0")
    if ! [[ -f ca-key.pem ]]
    then

        # generating ca key ...
        openssl genpkey -algorithm RSA -out ca-key.pem -config ./openssl.conf
        # openssl req -new -sha256 -nodes -newkey rsa:4096 -keyout ca-key.pem -out ca.csr

        # generating new ca certificate with key ...
        openssl req -new -x509 -key ca-key.pem -out ca-cert.pem -days 365 -config ./openssl.conf
        # openssl x509 -req -sha256 -extfile x509.ext -extensions ca -in ca.csr -signkey ca-key.pem -days 1095 -out ca-cert.pem
    fi

    # creating a new certificate request for server with key ...
    openssl req -new -nodes -keyout server.key -out server.csr -config ./openssl.conf
    # openssl req -new -sha256 -nodes -newkey rsa:4096 -keyout server.key -out server.csr -config ./openssl.conf

    # signing certificate request ...
    # openssl x509 -req -days 365 -in server.csr -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server.crt
    openssl x509 -req -sha256 -CA ca-cert.pem -CAkey ca-key.pem -days 730 -CAcreateserial -extfile x509.ext -extensions server -in server.csr -out server.crt

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
