FROM debian:bookworm-slim as base

ARG DEBIAN_FRONTEND=noninteractive
ENV VIRTUAL_ENV=/opt/python/venv \
    APP_USER=app \
    TZ=Europe/Paris

USER root:root

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
    openvpn

COPY ./scripts /opt/openvpn/scripts

RUN mkdir -p /opt/openvpn /var/openvpn
WORKDIR /opt/openvpn

FROM base as openssl_tools

RUN apt-get install -y --no-install-recommends \
    openssl iproute2 jq netcat-openbsd

FROM openssl_tools as install_tools

RUN apt-get install -y --no-install-recommends \
    python3 python3-venv python3-pip git

RUN python3 -m venv $VIRTUAL_ENV && \
    . $VIRTUAL_ENV/bin/activate && \
    pip install /opt/openvpn/scripts[run] && \
    echo .

ADD conf.tar /opt/openvpn/

RUN . $VIRTUAL_ENV/bin/activate && \
    for proto in tcp udp; do \
         SERVER_PROTO=$proto jte -t ./conf/templates/openvpn_server.conf.j2 \
             > /opt/openvpn/conf/openvpn_${proto}.conf; \
    done

RUN CN=vpn bash ./scripts/build_server.sh

FROM base as openvpn

# Create a dedicated user
# RUN useradd -ms /bin/bash openvpn
# RUN openvpn --genkey secret /etc/openvpn/server/openssl/ta.key
COPY --from=install_tools /opt/openvpn/conf/openvpn* /opt/openvpn/
ENTRYPOINT [ "/usr/sbin/openvpn" ]
