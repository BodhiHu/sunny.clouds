# README

## Prerequisite

1 Install Vagrant

2 Start VMs with provions enabled:
> Remember to uncomment the provisions of Vagrantfile
```
~ vagrant up --provision
```

## Setup cluster

Follow steps from: [Install a Multi-node Kubernetes and KubeSphere Cluster](https://kubesphere.io/docs/v3.3/installing-on-linux/introduction/multioverview)

Create cluster config file and update it accordingly:
```
./kk create config \
  # --with-kubesphere v3.3.1 # if install kubesphere
```

Create cluster:
```
./kk create cluster -f cluster-config.yaml
```

Besides KubeKey, you can also use ks-installer to install kubesphere:
```
https://github.com/kubesphere/ks-installer
```

Create default StorageClass if none:
```
kubectl apply -f openebs/openebs-operator.yaml
kubectl patch storageclass openebs-device -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```
