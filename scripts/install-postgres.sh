#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=${NAMESPACE:-odoo}
RELEASE=${RELEASE:-crunchy-postgres}
VALUES=${VALUES:-infra/charts/crunchy-postgres/values-dev.yaml}

helm repo add crunchydata https://charts.crunchydata.com/ >/dev/null 2>&1 || true
helm repo update >/dev/null 2>&1

helm upgrade --install "$RELEASE" crunchydata/postgres-operator \
  --namespace "$NAMESPACE" \
  --create-namespace \
  -f "$VALUES"

echo "Postgres installed with values: $VALUES"
