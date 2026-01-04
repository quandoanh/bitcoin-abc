# Bitcoin ABC docker image
Sample of Bitcoin ABC docker image

## Prerequisite

### Docker engine

Docker engine is required and here's the guide to install it (at Installation Part 2: Docker Installation)
https://mmfpsolutions.io/products.html#mim-bootstrap

### Docker Hub or Github repository for docker image 

Because the docker image will be pulled by docker compose, and the docker compose by default will look for the images from cloud. Hence, you should have a repository in docker hub or github. In this guide, the docker hub is in use.

You can login to the docker hub by googling: "docker login", so you can login to docker hub from your linux server to allow pushing/pulling docker images to/from docker hub.

Once docker hub credential created, login to docker hub in linux/ubuntu server (terminal).

## Create Bitcoin ABC docker image

### Docker file

Use the below Dockerfile to create the image

```dockerfile
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
```

### Build and push the image

#### Buil
Stay in the same folder of the `Dockerfile` and run the below command. You will need to specify:
- **your_docker_hub_name** is your user id in docker hub.
- **image_name** is the image of the Bitcoin ABD node, for example `bitcoin-abc`
- Remember to keep the `.` at the end for the current folder containing `Dockerfile`.
```bash
sudo docker build -t [your_docker_hub_name]/[image_name]:latest .
```

#### Push
```bash
sudo docker push [your_docker_hub_name]/[image_name]:latest
```
