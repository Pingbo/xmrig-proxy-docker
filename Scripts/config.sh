#!/bin/bash
cd /config
sed 's/"retries": 5/"retries": ${RETRIES}/' config.json \
sed 's/"donate-level": 2/"donat-level": ${DONATION}/' config.json \
sed 's/"coin": "xmr"/"coin": ${COIN}/' config.json \
sed 's/"custom-diff": 0/"custom-diff": ${CUSTOM_DIFF}/' config.json \
sed 's/"colors": true/"colors": false/' config.json \
sed 's/"url": "pool.minemonero.pro:5555"/"url": ${POOL_ADDR}/' config.json \
sed 's/"user": ""/"user": ${WALLET_ADDR}/' config.json \
sed 's/"pass": "x"/"user": ${PASSWORD}/' config.json \
sed 's/"0.0.0.0:3333"/${BIND_ADDR}/' config.json