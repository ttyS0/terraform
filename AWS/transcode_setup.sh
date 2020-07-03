#!/usr/bin/env bash

# Install components for adding other repositories
apt-get -y update
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Install Docker-CE and AWS CLI
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io awscli

# Copy over NVidia Driver meta-package and install cuda-drivers
aws s3 cp s3://skj-archive/transcode/pkg/nvidia-driver-local-repo-ubuntu1804-440.64.00_1.0-1_amd64.deb .
apt-get -y install ./nvidia-driver-local-repo-ubuntu1804-440.64.00_1.0-1_amd64.deb
apt-key add /var/nvidia-driver-local-repo-440.64.00/7fa2af80.pub
apt-get -y update
apt-get -y install cuda-drivers

# Install NVidia Docker Toolkit
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list
apt-get -y update
apt-get install -y nvidia-container-toolkit

# Add ubuntu user to docker group
usermod -a -G docker ubuntu

# Force non-interactive upgrade and clear out package cache
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
apt-get -y clean

# Setup transcoding mount
mkfs.xfs /dev/nvme0n1
echo "/dev/nvme0n1 /mnt xfs defaults 0 0" >>/etc/fstab
mount /mnt
mkdir -p /mnt/transcode/src
chown -R ubuntu /mnt

# Add an alias for the Docker other-transcode command
echo -e "\nalias tv='docker run --rm --gpus all -v \$(pwd):\$(pwd) -w \$(pwd) ttys0/other-transcode-nvidia --hevc --nvenc-temporal-aq'\n" >>/home/ubuntu/.bashrc

reboot
