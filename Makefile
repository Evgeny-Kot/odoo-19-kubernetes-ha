SHELL := /bin/bash
KUSTOMIZE ?= kustomize
KUBE_CONTEXT ?=
NAMESPACE ?= odoo
ENV ?= dev

.PHONY: bootstrap kind-up k3d-up deploy deploy-dev deploy-prod destroy test-manifests audit

bootstrap:
	@echo "Installing Gateway API CRDs (if missing)" 
	@kubectl $(if $(KUBE_CONTEXT),--context $(KUBE_CONTEXT),) apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml
	@echo "Bootstrap complete"

kind-up:
	@kind create cluster --name odoo19 || true

k3d-up:
	@k3d cluster create odoo19 || true

deploy:
	@$(KUSTOMIZE) build infra/overlays/$(ENV) | kubectl $(if $(KUBE_CONTEXT),--context $(KUBE_CONTEXT),) apply -f -

deploy-dev:
	@$(KUSTOMIZE) build infra/overlays/dev | kubectl $(if $(KUBE_CONTEXT),--context $(KUBE_CONTEXT),) apply -f -

deploy-prod:
	@$(KUSTOMIZE) build infra/overlays/prod | kubectl $(if $(KUBE_CONTEXT),--context $(KUBE_CONTEXT),) apply -f -

destroy:
	@kubectl $(if $(KUBE_CONTEXT),--context $(KUBE_CONTEXT),) delete ns $(NAMESPACE) --ignore-not-found=true


test-manifests: audit

audit:
	@mkdir -p .audit
	@$(KUSTOMIZE) build infra/overlays/dev > .audit/dev.yaml
	@$(KUSTOMIZE) build infra/overlays/stage > .audit/stage.yaml
	@$(KUSTOMIZE) build infra/overlays/prod > .audit/prod.yaml
	@kubeconform -strict -kubernetes-version 1.29.0 -summary \
	  -schema-location default \
	  -schema-location "file://$(PWD)/.kubeconform/schemas/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json" \
	  .audit/dev.yaml
	@kubeconform -strict -kubernetes-version 1.29.0 -summary \
	  -schema-location default \
	  -schema-location "file://$(PWD)/.kubeconform/schemas/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json" \
	  .audit/stage.yaml
	@kubeconform -strict -kubernetes-version 1.29.0 -summary \
	  -schema-location default \
	  -schema-location "file://$(PWD)/.kubeconform/schemas/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json" \
	  .audit/prod.yaml
	@if grep -nE 'example\.com|example\.org|ghcr\.io/example|vault\.example\.com|keycloak\.example\.com|minio\.example\.com' .audit/prod.yaml; then \
		echo "Blacklisted placeholders found in prod render"; \
		exit 1; \
	fi
