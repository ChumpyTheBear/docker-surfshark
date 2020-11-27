#!/bin/sh
rm -rf ovpn_configs*
wget --no-check-certificate -O ovpn_configs.zip https://api.surfshark.com/v1/server/configurations
unzip ovpn_configs.zip -d ovpn_configs
cd ovpn_configs
VPN_FILE=$(ls "${SURFSHARK_COUNTRY}"* | grep "${SURFSHARK_CITY}" | grep "${CONNECTION_TYPE}" | shuf | head -n 1)
echo Using file: ${VPN_FILE}
printf "${SURFSHARK_USER}\n${SURFSHARK_PASSWORD}" > vpn-auth.txt

echo Setting up UFW
echo "IPV6=no" >> /etc/default/ufw
ufw reset
ufw default deny outgoing
ufw default deny incoming
ufw allow out on tun0 from any to any
ufw allow out on eth0 to any port 1194 proto udp
ufw allow out on eth0 to any port 1443 proto tcp
ufw allow out on eth0 to 1.1.1.1 port 53 proto udp

if [ -n ${LAN_NETWORK}  ]
then
    DEFAULT_GATEWAY=$(ip -4 route list 0/0 | cut -d ' ' -f 3)
    ip route add "${LAN_NETWORK}" via "${DEFAULT_GATEWAY}" dev eth0
    echo Adding ip route add "${LAN_NETWORK}" via "${DEFAULT_GATEWAY}" dev eth0 for attached container web ui access
    echo Do not forget to expose the ports for attached container we ui access
    ufw allow in on eth0 from ${LAN_NETWORK} to any
    echo Added firewall rule to allow incoming connections from ${LAN_NETWORK}
fi

if [ -n ${ENABLE_DOCKERNETWORK}  ]
then
    ufw allow in on eth0 from 172.17.0.0/16 to any
    ufw allow in on eth0 from 172.18.0.0/16 to any
    echo Added firewall rule to allow incoming connections from default internal Docker network
fi

ufw enable

openvpn --config $VPN_FILE --auth-user-pass vpn-auth.txt