Odoo 19 Enterprise on Kubernetes — HA / Clustered Reference Architecture

![Kubernetes](https://img.shields.io/badge/Kubernetes-1.29%2B-blue)
![Gateway API](https://img.shields.io/badge/Gateway%20API-v1-green)
![Vault](https://img.shields.io/badge/Secrets-Vault-9cf)
![License](https://img.shields.io/badge/License-Apache--2.0-lightgrey)

---

Production-grade reference architecture for running Odoo 19 Enterprise in high-availability
clustered mode on Kubernetes.
This repository shows how to run Odoo the right way in Kubernetes using:
- Gateway API (instead of classic Ingress)
- CrunchyData PostgreSQL (HA + backups)
- Vault + External Secrets (no plaintext secrets)
- oauth2-proxy + Keycloak to protect Odoo database endpoints
- Redis for cache/session/bus
- Immutable Odoo image with all enterprise and custom addons baked in
- Kustomize overlays for dev / stage / prod
- Strict CI and local audit with kubeconform

---

Why this exists
There is almost no practical documentation on how to run Odoo in true HA/clustered mode on
Kubernetes with modern platform practices.
This project represents an implementation based on:
- official Odoo recommendations,
- Kubernetes best practices,
- and practical platform engineering experience.

Some decisions here were made based on what was technically correct and reproducible, rather than what is commonly shown in tutorials.

Key Architectural Decisions:
Immutable Odoo image (critical for clustering)
All enterprise and custom addons are baked into the Docker image at build time.
This guarantees:
- identical code on every replica
- no RWX addon volumes
- no initContainers copying code
- safe rolling upgrades by image tag
Only the filestore is shared via RWX PVC.
Gateway API routing
- / → Odoo
- longpolling/bus → Odoo with correct timeouts
- /web/database/* → oauth2-proxy → Odoo

---

Vault-driven secrets
No secrets in Git. Everything comes from Vault via External Secrets.
Proper PostgreSQL for Odoo HA
CrunchyData Postgres with pgBackRest backups and replication.

---

Repository Structure:
odoo/
addons/
custom/
enterprise/
Dockerfile
entrypoint.sh
odoo.conf.template
infra/
base/
overlays/
dev/
stage/
prod/
docs/
diagrams/
runbooks/
scripts/
examples/
.github/
Local / CI Audit (strict)

---

This repo includes a strict audit that must pass:
make audit
It validates:
- kustomize build for dev/stage/prod
- kubeconform strict schema validation (Kubernetes 1.29)
- no placeholder domains in prod manifests

How to use (dev)
make kind-up
make deploy-dev

---

Skills demonstrated here
- Kubernetes platform design
- Gateway API
- Vault + External Secrets
- oauth2-proxy / OIDC integration
- PostgreSQL HA for stateful apps
- Kustomize overlays
- Secure container practices
- Production-grade CI validation

---

Important note
Because of the lack of clear official guidance for this stack, this implementation was built to the extent that the architecture was understood, tested, and validated to be technically correct and reproducible.
It is meant to be a reference platform design, not a copy-paste deployment.