#!/bin/bash

set -ex

ssh-keygen -q -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
touch ~/.ssh/authorized_keys
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod -R 600 ~/.ssh
mkdir -p /var/run/sshd
service ssh start && sleep 1
eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_rsa
service ssh restart
