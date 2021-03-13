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
civo kubernetes create interesting-times-gang -n3 --wait --remove-applications=traefik -s g3.k3s.large tycho --region NYC1
civo kubernetes config interesting-times-gang -s
```

2. Run the following ( With your variables):

```
// Example Slack webhook within a Slack App
SLACK_FALCO_WEBHOOK_URL="https://hooks.slack.com/services/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" \
SLACK_PROMETHEUS_WEBHOOK_URL="https://hooks.slack.com/services/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" \
SLACK_PROMETHEUS_CHANNEL=alerts DOMAIN=cloudskunkworks.co.uk \
make install
```
