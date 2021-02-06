# kube-microcosm

A cluster that represents how a small start-up might be successful using a single Kubernetes cluster.

This is an opinionated illustration of a Kubernetes cluster and out-of-the-box applications.

![](images/diagram.svg)

## Showcase

Showcasing the following projects within this cluster...

![](images/projects.png)

## Requirements

- `step`
- `helm`
- `kubectl`


## Installation


1. Ensure an existing Kubernetes cluster config is active. I like using [civo](https://www.civo.com).

```
civo kubernetes create interesting-times-gang -n3 --wait --remove-applications=traefik
civo kubernetes config interesting-times-gang -s
```

2. Run the following ( With your variables):

```
SLACK_FALCO_WEBHOOK_URL="https://foo" \
SLACK_PROMETHEUS_WEBHOOK_URL="https://bar" \
SLACK_PROMETHEUS_CHANNEL=alerts DOMAIN=jonesax.dev \
make install
```
