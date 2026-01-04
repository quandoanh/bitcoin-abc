FROM debian:stable

RUN apt update && apt install -y procps wget bzip2 curl jq iproute2 ca-certificates && rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/bitcoin-abc.tar.gz https://download.bitcoinabc.org/0.32.5/linux/bitcoin-abc-0.32.5-x86_64-linux-gnu.tar.gz && \
    tar -xvf /tmp/bitcoin-abc.tar.gz --transform 's/bitcoin-abc-0.32.5/bitcoin-abc/' && \
    mv ./bitcoin-abc/bin/* /usr/bin/. && \
    mv ./bitcoin-abc/include/* /usr/include/. && \
    mv ./bitcoin-abc/lib/* /usr/lib/. && \
    rm -rf ./bitcoin-abc && \
    rm /tmp/bitcoin-abc.tar.gz && \
    chmod +x /usr/bin/bitcoin* /usr/bin/iguana /usr/bin/proof-manager-cli

WORKDIR /data

#RUN wget -O /data/p2pool_peers.txt https://xmrvsbeast.com/p2pool/sidechain_configs/mini_peerlist/p2pool_peers.txt
#EXPOSE 13333 37888
#CMD [ "/usr/local/bin/p2pool", "--host", "127.0.0.1", "--rpc-port", "18081", "--zmq-port", "18083", "--wallet", "47LEKYMMBw97XEmuCbnm2z1qFg6MFXXqBGL2QJNtKTQZYmqvQ7uBpf22Qzu4UifrHpbL5Nbhkvs5nGgJFn1Tz4jL8Fispw4", "--stratum", "0.0.0.0:13333", "--p2p", "0.0.0.0:37888", "--mini", "--log-file", "/data/p2pool.log" ]

EXPOSE 8339 9009
CMD [ "/usr/bin/bitcoind", "-conf=/data/bitcoin.conf", "-datadir=/data" ]
