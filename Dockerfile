FROM ubuntu:latest
LABEL maintainer.name="ChumpyTheBear" \
    description="OpenVPN client configured for SurfShark VPN"
WORKDIR /vpn
ENV SURFSHARK_USER=
ENV SURFSHARK_PASSWORD=
ENV SURFSHARK_COUNTRY=
ENV SURFSHARK_CITY=
ENV CONNECTION_TYPE=udp
ENV LAN_NETWORK=
HEALTHCHECK --interval=60s --timeout=10s --start-period=30s CMD curl -L 'https://ipinfo.io'
COPY startup.sh .
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    openvpn \
    wget \
    unzip \
    coreutils \
    curl && chmod +x ./startup.sh
ENTRYPOINT [ "./startup.sh" ]
