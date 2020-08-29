#!/usr/bin/env bash

# Install components for adding other repositories
apt-get -y update
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common awscli

# Copy over NVidia Driver meta-package and install cuda-drivers
aws s3 cp s3://skj-archive/transcode/pkg/nvidia-driver-local-repo-ubuntu2004-450.51.06_1.0-1_amd64.deb .
apt-get -y install ./nvidia-driver-local-repo-ubuntu2004-450.51.06_1.0-1_amd64.deb
apt-key add /var/nvidia-driver-local-repo-ubuntu2004-450.51.06/7fa2af80.pub

# Install NVidia Docker Toolkit
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu20.04/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list
apt-get -y update
apt-get install -y docker.io cuda-drivers nvidia-container-toolkit

# Add ubuntu user to docker group
usermod -a -G docker ubuntu

# Force non-interactive upgrade and clear out package cache
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
apt-get -y clean

# Setup transcoding mount
mkfs.xfs /dev/nvme1n1
echo "/dev/nvme1n1 /mnt xfs defaults 0 0" >>/etc/fstab
mount /mnt
mkdir -p /mnt/transcode/src
chown -R ubuntu /mnt

# Add an alias for the Docker other-transcode command
echo -e "\nalias tv='docker run --rm --gpus all -v \$(pwd):\$(pwd) -w \$(pwd) ttys0/other-transcode-nvidia --hevc --nvenc-temporal-aq'\n" >>/home/ubuntu/.bashrc

reboot
