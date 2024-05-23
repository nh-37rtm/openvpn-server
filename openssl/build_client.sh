#! /bin/bash

set -euxab

{ 
    cd $(dirname -- "$0")

    # generating  client key
    openssl genpkey -algorithm RSA -out client-key.pem -config openssl.conf
    # generating  client sign request
    openssl req -new -key client-key.pem -out client-csr.pem -config openssl.conf
    # signing client certificate with ca
    openssl x509 -req -in client-csr.pem -CA ca-cert.pem -CAkey ca-key.pem -out client-cert.pem -days 365 -CAcreateserial
}





