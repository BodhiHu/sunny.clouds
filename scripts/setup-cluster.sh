#!/bin/bash

export PATH=$PATH:/app/clouds-native/.bin

rke up --config /app/clouds-native/cluster-in-docker/rke-cluster.yml
