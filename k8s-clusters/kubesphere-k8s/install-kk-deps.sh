#!/bin/bash

# Install KubeKey required dependencies
# see https://kubesphere.io/docs/v3.3/installing-on-linux/introduction/multioverview/#dependency-requirements

set -x

sudo apt-get install -y socat conntrack ebtables ipset
