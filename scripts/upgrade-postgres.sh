#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=${NAMESPACE:-odoo}
RELEASE=${RELEASE:-crunchy-postgres}
VALUES=${VALUES:-infra/charts/crunchy-postgres/values-prod.yaml}

helm repo add crunchydata https://charts.crunchydata.com/ >/dev/null 2>&1 || true
helm repo update >/dev/null 2>&1

helm upgrade "$RELEASE" crunchydata/postgres-operator \
  --namespace "$NAMESPACE" \
  -f "$VALUES"

echo "Postgres upgraded with values: $VALUES"
