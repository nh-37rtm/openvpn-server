FROM debian:bookworm-slim as base


ARG DEBIAN_FRONTEND=noninteractive
ENV VIRTUAL_ENV=/opt/python/venv \
    APP_USER=app \
    TZ=Europe/Paris

USER root:root

# python execution environment
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    openvpn openssl jq iproute2

COPY ./server/ /etc/openvpn/server/
COPY ./openssl /etc/openvpn/server/openssl/

# Create a dedicated user
# RUN useradd -ms /bin/bash openvpn

RUN mkdir -p \
    /etc/openvpn/server/client-configs /var/openvpn/

WORKDIR /etc/openvpn/server
# RUN openvpn --genkey secret ta.key

ENTRYPOINT [ "/usr/sbin/openvpn" ]

CMD [ \ 
        "--cd", \
        "/etc/openvpn/server/", \
        "--config", \
        "/etc/openvpn/server/openvpn.conf" ]
