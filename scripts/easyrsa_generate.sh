#! /bin/bash

set -euxab

{ 

    set -euxab

    cd $(dirname -- "$0")/../easyrsa
    export EASYRSA_BATCH=1
    export EASYRSA_REQ_CN=ascs-npt.37rtm.fr

    ./easyrsa init-pki
    ./easyrsa build-ca nopass
    ./easyrsa gen-req ascs-npt nopass
    ./easyrsa sign-req server ascs-npt
    # ./easyrsa gen-dh

    unset EASYRSA_REQ_CN
    ./easyrsa build-client-full user1

    cp easyrsa/pki/private/ascs-npt.key openssl/server-key.pem
    cp easyrsa/pki/issued/ascs-npt.crt openssl/server-cert.pem
    cp easyrsa/pki/private/ca.key openssl/ca-key.pem
    cp easyrsa/pki/ca.crt openssl/ca-cert.pem
    cp easyrsa/pki/dh.pem openssl/dh.pem

    cp easyrsa/pki/issued/user1.crt openssl/client-cert.pem
    cp easyrsa/pki/private/user1.key openssl/client-key.pem


}
