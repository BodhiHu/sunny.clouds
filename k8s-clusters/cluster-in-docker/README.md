# NOTEs

### Generate SSH keys
```
ssh-keygen -q -t rsa -b 2048 -f ./10.21.108.11/.ssh/id_rsa -N ""
```

### Start RKE
```
rke up --config ./rancher-cluster.yml
```
