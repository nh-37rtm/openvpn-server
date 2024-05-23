FROM debian:bookworm-slim as base

ARG DEBIAN_FRONTEND=noninteractive
ENV VIRTUAL_ENV=/opt/python/venv \
    APP_USER=app \
    TZ=Europe/Paris

USER root:root

# python execution environment
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    openvpn

RUN mkdir -p \
    /etc/openvpn/server/client-configs /var/openvpn/

RUN ln -s /etc/openvpn/openssl /etc/openvpn/server/openssl
WORKDIR /etc/openvpn/server

COPY easyrsa/pki/private/ascs-npt.key /etc/openvpn/server/openssl/server-key.pem
COPY easyrsa/pki/issued/ascs-npt.crt /etc/openvpn/server/openssl/server-cert.pem
COPY easyrsa/pki/private/ca.key /etc/openvpn/server/openssl/ca-key.pem
COPY easyrsa/pki/ca.crt /etc/openvpn/server/openssl/ca-cert.pem
COPY easyrsa/pki/dh.pem /etc/openvpn/server/openssl/dh.pem

# Create a dedicated user
# RUN useradd -ms /bin/bash openvpn
# RUN openvpn --genkey secret /etc/openvpn/server/openssl/ta.key

ENTRYPOINT [ "/usr/sbin/openvpn" ]

CMD [ \ 
        "--cd", \
        "/etc/openvpn/server/", \
        "--config", \
        "/etc/openvpn/server/openvpn.conf" ]