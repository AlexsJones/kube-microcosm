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

