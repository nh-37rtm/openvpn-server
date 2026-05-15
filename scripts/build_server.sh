#! /bin/bash

set -euxab

OPENSSL_DIR=$(dirname -- "$0")/../conf/openssl


prerequisites()
{
    type openssl test

    for pr in conf/openssl.conf conf/x509_extensions.conf
    do
        test -e ${OPENSSL_DIR}/${pr}
    done

    echo "CN (required to be the server name) is : $CN"
    
}

prerequisites >/dev/null

generate_certs()
{
    if ! [[ -f ca-key.pem ]]
    then

        # generating ca key ...
        openssl genpkey -algorithm RSA -out ca-key.pem -config conf/openssl.conf
        # generating new ca certificate with key ...
        openssl req -new -x509 -key ca-key.pem -out ca-cert.pem -days 3650 -config conf/openssl.conf \
            -text \
            # -extfile conf/x509_extensions.conf -extensions v3_req_ca
    fi

    # creating a new certificate request for server with key ...
    openssl req -new -nodes -keyout server-key.pem -out server-cert.pem -config conf/openssl.conf

    # signing certificate request ...
    # openssl x509 -req -days 365 -in server.csr -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server.crt
    openssl x509 -req -sha256 -in server-cert.pem \
        -CA ca-cert.pem -CAkey ca-key.pem\
        -out server-cert.pem -days 730 -CAcreateserial \
        -text -extfile conf/x509_extensions.conf -extensions v3_req_server

    if ! [[ -f dh.pem ]]
    then
        # generating dhparam file ...
        openssl dhparam -out dh.pem 2048
    fi


    if ! [[ -f ta.key ]]
    then
        # generating ta.key file ...
        openvpn --genkey secret ta.key
    fi
}


cd ${OPENSSL_DIR}
generate_certs