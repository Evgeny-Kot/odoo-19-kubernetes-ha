# Keycloak + oauth2-proxy Setup

## Steps
1. Import realm: [examples/keycloak-realm.json](../examples/keycloak-realm.json).
2. Create a confidential client and set redirect URI to `https://<odoo-domain>/oauth2/callback`.
3. Store client ID/secret in Vault under `kv/odoo/<env>`.
4. Deploy oauth2-proxy and verify `/web/database/manager` is protected.

## Optional
- Protect `/web/login` by adding an extra HTTPRoute rule to route that path through oauth2-proxy.
