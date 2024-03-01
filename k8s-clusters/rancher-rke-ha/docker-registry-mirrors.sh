#!/bin/sh

set -x

DOCKER_CN_MIRRORS="
{
  \"registry-mirrors\": [
    \"https://docker.mirrors.ustc.edu.cn\",
    \"https://4sjn347i.mirror.aliyuncs.com\"
  ]
}
"

sudo echo $DOCKER_CN_MIRRORS > /etc/docker/daemon.json
sudo echo "
218.104.71.170 docker.mirrors.ustc.edu.cn
116.62.81.173 4sjn347i.mirror.aliyuncs.com
" >> /etc/hosts

