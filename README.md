# docker-surfshark

Docker container with OpenVPN client preconfigured for SurfShark

Its purpose is to provide the [SurfShark VPN](https://surfshark.com/) to all your containers. 

The link is established using the [OpenVPN](https://openvpn.net/) client.

## Configuration

The container is configurable using 5 environment variables:

| Name | Mandatory | Description |
|------|-----------|-------------|
|SURFSHARK_USER|Yes|Username provided by SurfShark|
|SURFSHARK_PASSWORD|Yes|Password provided by SurfShark|
|SURFSHARK_COUNTRY|No|The country, supported by SurfShark, in which you want to connect|
|SURFSHARK_CITY|No|The city of the country in which you want to connect|
|CONNECTION_TYPE|No|The connection type that you want to use: tcp, udp|
|LAN_NETWORK|Yes|Lan network used to access the web ui of attached containers. Comment out or leave blank: example 192.168.0.0/24|

`SURFSHARK_USER` and `SURFSHARK_PASSWORD` are provided at this page, under the "Credentials" tab: [https://my.surfshark.com/vpn/manual-setup/main](https://my.surfshark.com/vpn/)

`SURFSHARK_COUNTRY` and `SURFSHARK_CITY` codes can be found at this page, under the "Files" tab: [https://my.surfshark.com/vpn/manual-setup/main](https://my.surfshark.com/vpn/manual-setup/main)

<p align="center">
    <img src="https://support.surfshark.com/hc/article_attachments/360038503393/mceclip0.png" alt="SurfShark credentials"/>
</p>

## Execution

You can run this image using [Docker compose](https://docs.docker.com/compose/)
** Remember: if you want to use the web gui of a container, you must open its ports on `docker-surfshark` as described below. **

```
version: "2"

services: 
    surfshark:
        build: https://github.com/ChumpyTheBear/docker-surfshark.git
        container_name: surfshark
        environment: 
            - SURFSHARK_USER=YOUR_SURFSHARK_USER
            - SURFSHARK_PASSWORD=YOUR_SURFSHARK_PASSWORD
            - SURFSHARK_COUNTRY=it
            - SURFSHARK_CITY=mil
            - CONNECTION_TYPE=udp
            - LAN_NETWORK=
        cap_add: 
            - NET_ADMIN
        devices:
            - /dev/net/tun
        ports:
            - 9091:9091 #we open here the port for transmission, as this container will be the access point for the others
        restart: unless-stopped
        dns:
            - 1.1.1.1
 
```

To manually test the connection run the following:

```sh
docker run -it --net=container:surfshark byrnedo/alpine-curl -L 'https://ipinfo.io'
```

Use the following for DNS Leak testing https://github.com/macvk/dnsleaktest

If you want access to an attached container's web ui you will also need to expose those ports.  The attached container must not be started until this container is up and fully running.
