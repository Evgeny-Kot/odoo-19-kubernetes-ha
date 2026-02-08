#!/usr/bin/env bash
set -euo pipefail

VAULT_ADDR=${VAULT_ADDR:-https://vault.default.yourdomain.tld}
VAULT_TOKEN=${VAULT_TOKEN:-""}
K8S_HOST=${K8S_HOST:-""}

if [[ -z "$VAULT_TOKEN" ]]; then
  echo "VAULT_TOKEN is required" >&2
  exit 1
fi

export VAULT_ADDR
export VAULT_TOKEN

vault auth enable kubernetes || true

vault write auth/kubernetes/config \
  kubernetes_host="$K8S_HOST" \
  token_reviewer_jwt=@/var/run/secrets/kubernetes.io/serviceaccount/token \
  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

vault policy write odoo-kv examples/vault/policy.hcl

vault write auth/kubernetes/role/odoo-external-secrets \
  bound_service_account_names=external-secrets \
  bound_service_account_namespaces=external-secrets \
  policies=odoo-kv \
  ttl=24h

echo "Vault bootstrap complete"
