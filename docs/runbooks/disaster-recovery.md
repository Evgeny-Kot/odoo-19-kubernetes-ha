# Disaster Recovery

## Postgres Restore
1. Use Crunchy pgBackRest restore into a new cluster.
2. Repoint Odoo DB connection to restored primary.

## Filestore Restore
- Restore RWX filestore from backups (NFS/Longhorn snapshots).
- Ensure file ownership matches Odoo UID.
