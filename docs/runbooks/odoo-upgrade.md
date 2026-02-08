# Odoo Upgrade Runbook

## Rolling Upgrade
1. Build and push new Odoo image tag.
2. Update overlay image tag.
3. Apply manifests: `make deploy-prod`.
4. Monitor rollout and readiness probes.

## Database Migrations
- Use a controlled maintenance window for major version upgrades.
- Run Odoo with `--update=all` only once.
- Validate on staging first.
