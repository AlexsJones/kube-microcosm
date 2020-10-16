.PHONY: deploy get-argocd-password helm-repos install post-install pre-install provision-linkerd
d=`date -v+8760H +"%Y-%m-%dT%H:%M:%SZ"`
provision-linkerd:
	step certificate create identity.linkerd.cluster.local ca.crt ca.key \
--profile root-ca --no-password --insecure --san identity.linkerd.cluster.local
	step certificate create identity.linkerd.cluster.local issuer.crt issuer.key --ca ca.crt --ca-key ca.key --profile intermediate-ca --not-after 8760h --no-password --insecure --san identity.linkerd.cluster.local
	helm install linkerd2 \
  --set-file global.identityTrustAnchorsPEM=ca.crt \
  --set-file identity.issuer.tls.crtPEM=issuer.crt \
  --set-file identity.issuer.tls.keyPEM=issuer.key \
  --set identity.issuer.crtExpiry=$(d) \
  linkerd/linkerd2
helm-repos:
	helm repo add linkerd https://helm.linkerd.io/stable
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo add falcosecurity https://falcosecurity.github.io/charts
	helm repo add jetstack https://charts.jetstack.io
	helm repo add argo https://argoproj.github.io/argo-helm
	helm repo add banzaicloud-stable https://kubernetes-charts.banzaicloud.com
	helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
	helm repo update
install: helm-repos provision-linkerd pre-install helm-install post-install
pre-install:
	kubectl create ns argocd || true
	kubectl create ns monitoring || true
	kubectl create ns cert-manager || true
	kubectl create ns ingress-nginx || true
	kubectl annotate ns argocd linkerd.io/inject=enabled
	kubectl annotate ns cert-manager linkerd.io/inject=enabled
	kubectl annotate ns monitoring linkerd.io/inject=enabled
	kubectl annotate ns ingress-nginx linkerd.io/inject=enabled
helm-install:
	@:$(call check_defined, SLACK_WEBHOOK_URL, has no value)
	helm install cert-manager --namespace cert-manager --version v1.0.2 jetstack/cert-manager --set=installCRDs=true
	helm install nginx ingress-nginx/ingress-nginx --version 3.3.0 --namespace ingress-nginx
	helm install argo argo/argo-cd -n argocd --set=server.extraArgs={--insecure}
	helm install gatekeeper gatekeeper/gatekeeper
	helm install sidekick falcosecurity/falcosidekick -n kube-system --set config.slack.webhookurl=${SLACK_WEBHOOK_URL} --set=config.debug=true
	helm install falco falcosecurity/falco -f resources/falco-config.yaml -n kube-system
post-install:
	sleep 20
	kubectl wait --for=condition=ready pods -l "app=webhook" -n cert-manager
	kubectl wait --for=condition=ready pods -l "app.kubernetes.io/name=ingress-nginx" -n ingress-nginx
	kubectl apply -f resources/ingress/ 
	kubectl apply -f resources/application-bootstrap.yaml -n argocd
get-argocd-password:
	kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
        $(error Undefined $1$(if $2, ($2))$(if $(value @), \
                required by target `$@')))
