# usage: docker run pingbo/xmrig-proxy -o miningpool.url:port -u username -p password -b 0.0.0.0:3333

FROM          ubuntu:latest

ENV           XMRIG_DIR /xmrig-proxy
ENV           XMRIG_BUILD_DIR $XMRIG_DIR/build

RUN           apt-get update && apt-get upgrade -y
RUN           apt-get install git build-essential cmake libuv1-dev uuid-dev -y

RUN           git clone https://github.com/xmrig/xmrig-proxy.git $XMRIG_DIR && cd $XMRIG_DIR
RUN           mkdir $XMRIG_BUILD_DIR && cd $XMRIG_BUILD_DIR && \
    cmake .. -DWITH_HTTPD=OFF && make
RUN           mv $XMRIG_BUILD_DIR/xmrig-proxy /usr/bin/

ENTRYPOINT    ["xmrig-proxy"]
