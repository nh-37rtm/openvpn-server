#! /bin/bash

set -euxab

prerequisites()
{
    type openssl test

    for pr in conf/openssl.conf conf/x509_extensions.conf ca-cert.pem ca-key.pem
    do
        test -e  "$pr"
    done

}

cd $(dirname -- "$0")/../openssl
prerequisites >/dev/null

{ 

    # generating  client key
    openssl genpkey -algorithm RSA -out client-key.pem -config conf/openssl.conf
    # generating  client sign request
    openssl req -new -key client-key.pem -out client-csr.pem -config conf/openssl.conf -text
    
    # signing client certificate with ca
    openssl x509 -req -in client-csr.pem \
        -CA ca-cert.pem -CAkey ca-key.pem \
        -out client-cert.pem -days 365 -CAcreateserial \
        -text -extfile conf/x509_extensions.conf -extensions v3_req_client
    
}





