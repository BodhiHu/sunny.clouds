# Sunny.Clouds

> cloud-native, distributed, high-avaible/concurrent/resilient

## Create local kubernetes cluster

### single node cluster with rancher

> https://docs.ranchermanager.rancher.io/pages-for-subheaders/rancher-on-a-single-node-with-docker#option-a-default-rancher-generated-self-signed-certificate

Run with `docker-compose`:
```
$ docker-compose -f rancher-kube-clusters/docker-compose-single-node.yaml up -d
```

OR run with `docker` directly:

```
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  --name rancher-kube-cluster \
  --cpus="1.0" --memory="4g" --memory-swap="4g" \
  --volume "../:/SunnyClouds"
  rancher/rancher:latest
```

### with rancher/rke
```
# Download RKE:
$ curl https://github.com/rancher/rke/releases/download/v1.3.16/rke_linux-amd64 -o .bin/rke
$
# Start docker nodes:
$ docker-compose -f ./cluster-in-docker/docker-compose.yaml up -d
$
# SSH to each docker node and run:
$ eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_rsa
$
# SSH to ubuntu-20.04-0 and run RKE:
$ chmod u+x clouds-native/.bin/rke 
$ ./rke up --config clouds-native/cluster-in-docker/rke-cluster.yml
```

### with Minikube
```
# minikube start --nodes 3 --kubernetes-version=v1.22.15 -p minikube-1.22.15 --container-runtime docker
# minikube start --nodes 3 --kubernetes-version=v1.23.13 -p minikube-1.23.13 --container-runtime docker
$ minikube start --nodes 3 --kubernetes-version=v1.24.7  -p minikube-1.24.7  --container-runtime docker
```

### with Kind

with K8S @ 1.22.15
```
$ ./kind/bin/kind create cluster --name kind-1.22.15 --config ./kind/clusters/multi-node-cluster-with-k8s-1.22.15.yaml
```

with K8S @ 1.24.7
```
$ ./kind/bin/kind create cluster --name kind-1.24.7 --config ./kind/clusters/multi-node-cluster-with-k8s-1.24.7
```

## Setup kubesphere services:

Install
```
kubectl apply -f https://github.com/kubesphere/ks-installer/releases/download/v3.3.0/kubesphere-installer.yaml

kubectl apply -f https://github.com/kubesphere/ks-installer/releases/download/v3.3.0/cluster-configuration.yaml
```

Inspect the logs of installation:
```
kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l 'app in (ks-install, ks-installer)' -o jsonpath='{.items[0].metadata.name}') -f
```

Check if `ks-console` is running:
```
kubectl get svc/ks-console -n kubesphere-system
```

When it prints below messages in console,:
```
Collecting installation results ...
#####################################################
###              Welcome to KubeSphere!           ###
#####################################################

Console: http://192.168.49.2:30880
Account: admin
Password: P@88w0rd

NOTES：
  1. After you log into the console, please check the
     monitoring status of service components in
     "Cluster Management". If any service is not
     ready, please wait patiently until all components
     are up and running.
  2. Please change the default password after login.

#####################################################
https://kubesphere.io             2022-10-31 05:54:15
#####################################################
```

then we can access `ks-console`:
```
minikube service ks-console -n kubesphere-system --url
```

<!------------------------------------------------------------------------------------------------
## Deprecated

#### Create Kind Cluster

```
$ ./kind/bin/kind create cluster --name kind --config ./kind/clusters/multi-node-cluster.yaml
```

#### Install zadig services

```
$ helm repo add koderover-chart https://koderover.tencentcloudcr.com/chartrepo/chart
$ helm repo update

$ kubectl create ns zadig

$ export NAMESPACE=zadig \
  export IP=127.0.0.1 \
  export PORT=31500

$ helm upgrade --debug -v 4 --timeout 300s --install zadig ./zadig-helm \
  --namespace ${NAMESPACE} \
  --version=1.14.0 \
  --set endpoint.type=IP \
  --set endpoint.IP=${IP} \
  --set gloo.gatewayProxies.gatewayProxy.service.httpNodePort=${PORT} \
  --set global.extensions.extAuth.extauthzServerRef.namespace=${NAMESPACE} \
  --set gloo.gatewayProxies.gatewayProxy.service.type=NodePort \
  --set "dex.config.staticClients[0].redirectURIs[0]=http://${IP}:${PORT}/api/v1/callback,dex.config.staticClients[0].id=zadig,dex.config.staticClients[0].name=zadig,dex.config.staticClients[0].secret=ZXhhbXBsZS1hcHAtc2VjcmV0"
```

Open ```http://127.0.0.1:31500``` to access dashboard.

-------------------------------------------------------------------------------------------------->
