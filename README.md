# kube-microcosm

A cluster that represents how a small start-up might be successful using a single Kubernetes cluster.

GitOps, Service-Mesh and observability techniques all out of the box.

_Up and running within 5 minutes..._

![](images/diagram.svg)

## Showcase

Showcasing the following projects within this cluster...

![](images/projects.png)

## Requirements 

- `step` 
- `helm` 
- `kubectl`


## Installation


1. Ensure an existing kubernetes cluster config is active
2. Run the following ( With your variables): 

```
SLACK_FALCO_WEBHOOK_URL="https://foo" \
SLACK_PROMETHEUS_WEBHOOK_URL="https://bar" \
SLACK_PROMETHEUS_CHANNEL=alerts DOMAIN=jonesax.dev \
make install
```

This will install the cluster level components and ready argocd to deploy user applications via the app-of-apps technique.

## User Applications

Users would be expected to operate within the ArgoCD control plane tier and utilise the App of Apps concept for bootstrapping with GitOps for day to day deployment.

![](images/apps.svg)

A quick refresh on GitOps [here](https://www.weave.works/technologies/gitops/)


## Screenshots

![](images/1.png)

![](images/2.png)

![](images/3.png)

Falco sidekick enables you to receive cluster security events in slack (and other integrations)...

![](images/falco.png)

Alert manager sending out notifications...

![](images/am.png)


## Web accessibility

This installation uses cert-manager to provision certs for a domain.

It is up to you to alter the domains used in resources/ingress to one you own and point that alias to the IP the cluster load balancer is available on.

