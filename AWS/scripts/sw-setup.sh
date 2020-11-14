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

# Add an alias for the Docker other-transcode command
echo -e "\nalias tv='docker run --rm -v \$(pwd):\$(pwd) -w \$(pwd) hub.skj.dev/img/other-transcode:sw-0.3.2 --x264-avbr'\n" >>/home/ubuntu/.bashrc

# Add bulk.sh script for bulk transcoding
echo 'IyEvdXNyL2Jpbi9lbnYgYmFzaAoKU1JDPSJzMzovL3Nrai1hcmNoaXZlL3RyYW5zY29kZS9zcmMvIgpMT0c9InMzOi8vc2tqLWxvZ3MvdHJhbnNjb2RlLyIKT1VUPSJzMzovL3Nrai1hcmNoaXZlL3RyYW5zY29kZS9vdXQvIgoKT0lGUz0iJElGUyIKSUZTPSQnXG4nCmZpbGVzPSgkKGF3cyBzMyBscyAke1NSQ30gfCBjdXQgLWQgJyAnIC1mIDEsMiwzIC0tY29tcGxlbWVudCB8IHNlZCAxZCkpCklGUz0iJE9JRlMiCgpmb3IgaXRlbSBpbiAiJHtmaWxlc1tAXX0iOyBkbwogIGVjaG8gInN0YXJ0aW5nIHRyYW5zY29kZSBvZiAke2l0ZW19Li4uLiIKICBhd3MgczMgY3AgIiR7U1JDfSR7aXRlbX0iIHNyYy8KICBkb2NrZXIgcnVuIC0tcm0gLXYgJChwd2QpOiQocHdkKSAtdyAkKHB3ZCkgaHViLnNrai5kZXYvaW1nL290aGVyLXRyYW5zY29kZTpzdy0wLjMuMiAtLXgyNjQtYXZiciAtLXgyNjQtcXVpY2sgLS10YXJnZXQgMTA4MHA9NTAwMCAtLWFsbC1lYWMzIC0tc3Vycm91bmQtYml0cmF0ZSAzODQgLS1zdGVyZW8tYml0cmF0ZSAxOTIgLS1wYXNzLWR0cyAtLWJ1cm4tc3VidGl0bGUgYXV0byAic3JjLyR7aXRlbX0iCiAgaWYgWyAhIC1mICIke2l0ZW19LmxvZyIgXTsgdGhlbgogICAgZWNobyAic29tZXRoaW5nIGJhZCBoYXBwZW5lZCB0byB0aGUgdHJhbnNjb2RlISBFWElUSU5HISIKICAgIGV4aXQgMQogIGVsc2UKICAgIGF3cyBzMyBtdiAiJHtpdGVtfS5sb2ciICR7TE9HfQogICAgYXdzIHMzIG12ICIke2l0ZW19IiAke09VVH0KICAgIGF3cyBzMyBybSAiJHtTUkN9JHtpdGVtfSIKICAgIHJtIC1mdiAic3JjLyR7aXRlbX0iCiAgICBlY2hvICJjb21wbGV0ZWQgdHJhbnNjb2RlIG9mICR7aXRlbX0uLi4uIgogIGZpCmRvbmUK' | base64 -d >/home/ubuntu/transcode/bulk.sh
chmod a+x /home/ubuntu/transcode/bulk.sh

# Update permissions
chown -R ubuntu /home/ubuntu/transcode
