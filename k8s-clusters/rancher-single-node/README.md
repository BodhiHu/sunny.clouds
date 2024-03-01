# single node cluster with rancher

> https://docs.ranchermanager.rancher.io/pages-for-subheaders/rancher-on-a-single-node-with-docker#option-a-default-rancher-generated-self-signed-certificate

Run with `docker-compose`:
```
$ docker-compose -f docker-compose-single-node.yaml up -d
```

OR run with `docker` directly:

```
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  --name rancher-kube-cluster \
  --cpus="1.0" --memory="4g" --memory-swap="4g" \
  --volume "../:/sunny-clouds"
  #-e CATTLE_AGENT_IMAGE="registry.cn-hangzhou.aliyuncs.com/rancher/rancher-agent:v2.7.1" \
  #registry.cn-hangzhou.aliyuncs.com/rancher/rancher:v2.7.1
  rancher/rancher:latest
```
