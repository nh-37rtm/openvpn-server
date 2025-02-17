FROM debian:bookworm-slim as base

ARG DEBIAN_FRONTEND=noninteractive
ENV VIRTUAL_ENV=/opt/python/venv \
    APP_USER=app \
    TZ=Europe/Paris

USER root:root

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
    openvpn

FROM base as openssl

RUN apt-get install -y --no-install-recommends \
    openssl iproute2 jq netcat-openbsd

WORKDIR /root

FROM base as openvpn

RUN mkdir -p \
    /etc/openvpn/server/client-configs /var/openvpn/

RUN ln -s /etc/openvpn/openssl /etc/openvpn/server/openssl
WORKDIR /etc/openvpn/server

# Create a dedicated user
# RUN useradd -ms /bin/bash openvpn
# RUN openvpn --genkey secret /etc/openvpn/server/openssl/ta.key

ENTRYPOINT [ "/usr/sbin/openvpn" ]

CMD [ \ 
        "--cd", \
        "/etc/openvpn/server/", \
        "--config", \
        "/etc/openvpn/server/openvpn.conf" ]