Security Model
This platform was designed with the assumption that Odoo is a stateful business-critical system and must run under the same security standards as any other production workload in Kubernetes.

Security here is not an afterthought — it is built into the architecture.
Secrets Management
Secrets are never stored in Git and never hardcoded in manifests.

HashiCorp Vault is the single source of truth for:
- PostgreSQL credentials
- Odoo admin password
- SMTP credentials
- OAuth2 / Keycloak client secrets
- Any future application secrets

Secrets reach the cluster only through External Secrets Operator, which synchronizes Vault KV paths into Kubernetes Secrets.
Kubernetes Secrets are treated as runtime materialization of Vault data, not as a storage layer.

Vault Authentication Model

Vault uses the Kubernetes auth method with:
- Dedicated service accounts
- Per-environment roles
- Strict Vault policies mapped to KV paths

Each environment (dev/stage/prod) can be restricted to its own secret scope.
Access Control (RBAC)

Every component runs with its own service account:
- Odoo
- oauth2-proxy
- External Secrets Operator

RBAC follows the principle of least privilege.
Network Policies
Network communication is explicitly restricted:
Gateway → Odoo, oauth2-proxy
Odoo → Redis, PostgreSQL
External Secrets → Vault
Everything else → Denied
TLS Model
TLS terminates at the Gateway API.
Internal TLS for PostgreSQL is supported and recommended (via CrunchyData).
OAuth2 and Vault communication occurs over HTTPS only.
Odoo Image Hardening

The Odoo container follows secure container practices:
- Runs as non-root user
- No addon volumes, no runtime code injection
- All addons are baked into the image
- Only filestore PVC is mounted
Supply Chain Security

CI enforces:
- YAML linting
- Kustomize build validation
- kubeconform strict schema validation
- Shell script linting

Threat Model Considerations

This design protects against:
- Secret leakage
- Addon/code drift between replicas
- Unauthorized access to Odoo database management endpoints
- Lateral pod-to-pod movement
- Misconfigured exposure of sensitive paths

Summary

This repository demonstrates how to run Odoo in Kubernetes with platform-grade security controls.