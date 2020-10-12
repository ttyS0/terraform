#!/usr/bin/env bash

apt-get -y update
apt-get install -y docker.io awscli

systemctl enable docker
systemctl start docker

# Add ubuntu user to docker group
usermod -a -G docker ubuntu

# Force non-interactive upgrade and clear out package cache
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
apt-get -y clean

mkdir -p /home/ubuntu/transcode/src
chown -R ubuntu /home/ubuntu/transcode

# Add an alias for the Docker other-transcode command
echo -e "\nalias tv='docker run --rm -v \$(pwd):\$(pwd) -w \$(pwd) hub.skj.dev/img/other-transcode:sw-0.3.2 --x264-avbr'\n" >>/home/ubuntu/.bashrc

