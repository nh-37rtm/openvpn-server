#! /bin/bash

set -euxab

CONF_DIR=$(dirname -- "$0")/../conf
OPENSSL_DIR=${CONF_DIR}/openssl


prerequisites()
{
    type openssl test
    echo "CN (required to be the server name) is : $CN"
}

prerequisites >/dev/null

function generate_certs()
{ 

    for pr in conf/openssl.conf conf/x509_extensions.conf ca-cert.pem ca-key.pem
    do
        test -e ${pr}
    done

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


function generate_ovpn()
{

    for pr in ca-cert.pem client-cert.pem client-key.pem ta.key
    do
        test -e ${OPENSSL_DIR}/${pr}
    done
    

    FIRST_IPV6=$(ip --json address | jq '.[] | select(.ifname | test("ens|eth")) | .addr_info[1] | select( .family == "inet6" ) | .local')

    CA_CERT_PEM=$(cat ${OPENSSL_DIR}/ca-cert.pem) \
    CA_CLIENT_CERT_PEM=$(cat ${OPENSSL_DIR}/client-cert.pem) \
    CA_CLIENT_KEY_PEM=$(cat ${OPENSSL_DIR}/client-key.pem) \
    CA_TA_KEY_PEM=$(cat ${OPENSSL_DIR}/ta.key) \
        jte --template ./conf/templates/openvpn_client.conf.j2 > ${CONF_DIR}/client-configs/${CN}.ovpn
}

(
    cd ${OPENSSL_DIR}
    generate_certs
)
generate_ovpn