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
COPY startup.sh .
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    openvpn \
    wget \
    unzip \
    coreutils \
    ufw \
    curl && chmod +x ./startup.sh && rm -rf /var/lib/apt/lists/*
ENTRYPOINT [ "./startup.sh" ]
