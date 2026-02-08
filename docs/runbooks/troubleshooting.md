# Troubleshooting

## Common Checks
- `kubectl get pods -n odoo`
- `kubectl logs deploy/odoo -n odoo`
- Verify External Secrets sync status.

## Gateway Issues
- Confirm Gateway and HTTPRoute status.
- Validate listeners and certificates.

## Odoo Bus/Longpoll
- Ensure `/longpolling` route uses extended timeouts.
