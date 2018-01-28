
FROM ubuntu:xenial
LABEL Name=xmrig-proxy-docker Version=0.0.1

#Variables for configuration
ENV RETRIES=5 \
DONATION=2 \
POOL_ADDR="pool.etn.spacepools.org" \
WALLET_ADDR="etnk6o9kxjg2d4eWbtGqUUCpzouAPM2ZnUzfBwXFNPCQUmMQcxcELFZF82NRLoE71YWNxEzTo8z14E9pqTn4oae46pTU6QFVWP" \
PASSWORD="x" \
CUSTOM_DIFF=0 \
BIND_ADDR="0.0.0.0:3333" \
COIN="xmr"

#Installation dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    libuv1-dev \
    uuid-dev \
    libmicrohttpd-dev

#Installation
RUN git clone https://github.com/xmrig/xmrig-proxy.git \
 && mv xmrig-proxy xmrig-proxy-build \
 && cd xmrig-proxy-build \ 
 && mkdir build \ 
 && cd build \
 && cmake .. \ 
 && make \
 && mkdir /xmrig-proxy \
 && mv xmrig-proxy /xmrig-proxy/ \
 && cd ../../ \
 && mkdir /config \
 && mv /xmrig-proxy-build/src/config.json /config/

#Cleanup
RUN apt-get purge -y git build-essential cmake \
 && rm -rf /var/lib/apt/lists/** \
 && rm -rf xmrig-proxy-build

COPY /Scripts /Scripts

WORKDIR /Scripts
ENTRYPOINT ["sh ./run-proxy.sh"]