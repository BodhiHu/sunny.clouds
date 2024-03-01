#!/bin/bash

set -ex

cat .bashrc >> ~/.bashrc

zypper -n install make

curl -O https://golang.google.cn/dl/go1.19.3.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz
rm go1.19.3.linux-amd64.tar.gz
