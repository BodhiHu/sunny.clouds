# README

## Prerequisite

1 Install Vagrant

2 Start VMs with provions enabled:
> Remember to uncomment the provisions of Vagrantfile
```
~ vagrant up --provision
```

## Setup K8S cluster with Rancher/RKE

1 Install rancher/rke
```
https://rancher.com/docs/rke/latest/en/installation/
```

2 Deploy kubernetes cluster with RKE:
```
~ rke up --config rke-cluster.yml
```

3 Set `kubeconfig` for `kubctl` & `helm`:
```
export KUBECONFIG=$(pwd)/kube_config_rke-cluster.yml
```
or,
```
alias kubectl="kubectl --kubeconfig=\"kube_config_rke-cluster.yml\""
alias helm="helm --kubeconfig=\"kube_config_rke-cluster.yml\""
```

## Deploy Rancher to cluster:

Follow steps from:
> [Install/Upgrade Rancher on a Kubernetes Cluster](https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster)

To set up Rancher,(in short)

###  Add the Helm chart repository
```
~ helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
```
### Create a namespace for Rancher
```
~ kubectl create namespace cattle-system
```
* Choose your SSL configuration
> We're using the default:
> Rancher Generated Certificates (Default),	ingress.tls.source=rancher

### Install cert-manager (skip this step if you're using your own CA)

These instructions are adapted from the [official cert-manager documentation](https://cert-manager.io/docs/installation/supported-releases/#installing-with-helm)

```
# If you have installed the CRDs manually instead of with the `--set installCRDs=true` option added to your Helm install command, you should upgrade your CRD resources before upgrading the Helm chart:
kubectl apply -f cert-manager/cert-manager-1.7.3.crds.yaml
# source: https://github.com/cert-manager/cert-manager/releases/download/v1.7.3/cert-manager.crds.yaml

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.7.3 \
  --set webhook.timeoutSeconds=3600
  #--set installCRDs=true

# IF helm install failed, then TRY to install with `kubectl`: 
helm --namespace cert-manager delete cert-manager
kubectl -v 5 apply -f cert-manager/cert-manager-1.7.3.yaml
```

Once you’ve installed cert-manager, you can verify it is deployed correctly by checking the cert-manager namespace for running pods:

```
kubectl get pods --namespace cert-manager

NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-5c6866597-zw7kh               1/1     Running   0          2m
cert-manager-cainjector-577f6d9fd7-tr77l   1/1     Running   0          2m
cert-manager-webhook-787858fcdb-nlzsq      1/1     Running   0          2m
```

### Install Rancher with Helm and your chosen certificate option

  - Set the hostname to the DNS name you pointed at your load balancer.
  - Set the bootstrapPassword to something unique for the admin user.
  - To install a specific Rancher version, use the --version flag, example: --version 2.3.6

```
helm -v 5 install rancher rancher-stable/rancher \
  --debug \
  --namespace cattle-system \
  --set hostname=bodhitree.com \
  --set bootstrapPassword=bodhicitta \
  --set ingress.tls.source=secret \
  --set privateCA=true
```

Wait for Rancher to be rolled out:
```
kubectl -n cattle-system rollout status deploy/rancher
Waiting for deployment "rancher" rollout to finish: 0 of 3 updated replicas are available...
deployment "rancher" successfully rolled out
```

###  Verify that the Rancher server is successfully deployed

After adding the secrets, check if Rancher was rolled out successfully:

```
kubectl -n cattle-system rollout status deploy/rancher
Waiting for deployment "rancher" rollout to finish: 0 of 3 updated replicas are available...
deployment "rancher" successfully rolled out
```

check the status of the deployment by running the following command:

```
kubectl -n cattle-system get deploy rancher
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
rancher   3         3         3            3           3m
```

### Save your options

## Notes

### Run `kubectl` to inspect cluster
```
~ kubectl --kubeconfig="kube_config_rke-cluster.yml" get -A nodes
```

### Run `helm` with cluster
```
~ helm --kubeconfig="kube_config_rke-cluster.yml"
```

### SSH to Node 
```
ssh -i .vagrant/machines/node-3/virtualbox/private_key vagrant@192.168.50.13
```
or
```
vagrant ssh node-3
```

### Vagrant

Up VMs:
```
vagrant up
```

SSH to VM:
```
vagrant ssh node-1
```

Down VMs:
```
vagrant halt
```

Others:
```
vagrant suspend
vagrant resume
vagrant status
```

## Uninstalling
```
helm --namespace cert-manager delete cert-manager
kubectl delete -f cert-manager.yaml
kubectl delete namespace cert-manager
```
