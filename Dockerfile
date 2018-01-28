
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
 && mv -n /xmrig-proxy-build/src/config.json /config/

#Cleanup
RUN apt-get purge -y git build-essential cmake \
 && rm -rf /var/lib/apt/lists/** \
 && rm -rf xmrig-proxy-build

#Configuration
RUN cd /config \
 && sed 's/"retries": 5/"retries": ${RETRIES}/' config.json \
 && sed 's/"donate-level": 2/"donat-level": ${DONATION}/' config.json \
 && sed 's/"coin": "xmr"/"coin": ${COIN}/' config.json \
 && sed 's/"custom-diff": 0/"custom-diff": ${CUSTOM_DIFF}/' config.json \
 && sed 's/"colors": true/"colors": false/' config.json \
 && sed 's/"url": "pool.minemonero.pro:5555"/"url": ${POOL_ADDR}/' config.json \
 && sed 's/"user": ""/"user": ${WALLET_ADDR}/' config.json \
 && sed 's/"pass": "x"/"user": ${PASSWORD}/' config.json \
 && sed 's/"0.0.0.0:3333"/${BIND_ADDR}/' config.json

VOLUME [ "/config" ]
WORKDIR /xmrig-proxy
ENTRYPOINT ["./xmrig-proxy"]
CMD [ "-c /config/config.json" ]