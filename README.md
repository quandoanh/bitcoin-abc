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

#### Test
```bash
sudo docker run [your_docker_hub_name]/[image_name]
```
You should see the node and synchronization starts.

## Prepare configuration
The default configuration is `bitcoin.conf`, you should modify the `rpcauth`. 
- Download the file: `rpcauth.py`
```bash
wget https://raw.githubusercontent.com/Bitcoin-ABC/bitcoin-abc/refs/heads/master/share/rpcauth/rpcauth.py
chmod +x rpcauth.py
```
- Create RPC credential:
```bash
./rpcauth.py testuser userpasss
String to be appended to bitcoin.conf:
rpcauth=testuser:bccbb2753658aaa7d92c8c74177a312a$add6a36cabd0ff49cd240b64319f21539bd64d65ea73fdc2fb74de0414fbd841
Your password:
userpasss
```
- Copy the `rpcauth....` to the `bitcoin.conf` 
- Modify the ports if you need to.
- Create folder `/data/bitcoin-abc/data` if it doesn't exist
- Copy `bitcoin.conf` to `data/bitcoin-abc/data` folder


## Add to existing docker-compose

Copy the content of the docker-compose.yml to the existing docker-compose.yml. You can name the node as you like.
Then start up the service along with the existing services (in this sample, the new server is `bitcoin-abc`).
```bash
sudo docker compose up bitcoin-abc
```

