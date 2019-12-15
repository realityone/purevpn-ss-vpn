FROM ubuntu:18.04

ENV PUREVPN_VERSION 1.2.3
ENV SHADOWSOCKS_VERSION v1.7.2

RUN apt update && \
    apt install -y iproute2 wget curl iptables iputils* net-tools xz-utils supervisor && \
    echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4\n" > /etc/resolv.conf && \
    wget https://s3.amazonaws.com/purevpn-dialer-assets/linux/app/purevpn_${PUREVPN_VERSION}_amd64.deb -O /opt/purevpn.deb && \
    wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/${SHADOWSOCKS_VERSION}/shadowsocks-${SHADOWSOCKS_VERSION}-stable.x86_64-unknown-linux-musl.tar.xz -O /opt/shadowsocks.tar.xz && \
    cd /opt/ && \
    apt install -y ./purevpn.deb && \
    xz -d ./shadowsocks.tar.xz && \
    tar xf ./shadowsocks.tar && \
    cd / && \
    rm -rf /var/lib/apt/lists/*

VOLUME /etc/purevpn

ENV VPN_LOCATION=US
CMD ["/entrypoint.sh"]

ADD ./supervisor.conf /etc/supervisor/conf.d/supervisor.conf
ADD ./entrypoint.sh /entrypoint.sh
