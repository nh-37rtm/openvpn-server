FROM debian:bookworm-slim as base

ARG DEBIAN_FRONTEND=noninteractive
ENV VIRTUAL_ENV=/opt/python/venv \
    APP_USER=app \
    TZ=Europe/Paris

USER root:root

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
    openvpn

RUN mkdir -p \
    /opt/opvpn
WORKDIR /opt/openvpn

COPY ./scripts/ /opt/openvpn/scripts/

FROM base as openssl

RUN apt-get install -y --no-install-recommends \
    openssl iproute2 jq netcat-openbsd

FROM base as openvpn

# Create a dedicated user
# RUN useradd -ms /bin/bash openvpn
# RUN openvpn --genkey secret /etc/openvpn/server/openssl/ta.key

RUN 

ENTRYPOINT [ "/usr/sbin/openvpn" ]

CMD [ \ 
        "--cd", \
        "/opt/openvpn/", \
        "--config", \
        "/opt/openvpn/conf/server/openvpn.conf" ]