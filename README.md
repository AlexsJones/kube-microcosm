# kube-microcosm

A cluster that represents how a small start-up might be successful using a single Kubernetes cluster.
GitOps, Service-Mesh and observability techniques all out of the box.

![](images/diagram.png)

## Installation

Have an existing kubernetes cluster config active and run `make install`

This will install the cluster level components and ready argocd to deploy user applications via the app-of-apps technique.

![](images/1.png)

![](images/2.png)


## Requirements 

- `step` for key generation for linkerd2
- helm 
- kubectl
