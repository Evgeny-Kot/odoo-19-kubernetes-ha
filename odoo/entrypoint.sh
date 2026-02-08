#!/usr/bin/env bash
set -euo pipefail

TEMPLATE=/etc/odoo/odoo.conf.template
TARGET=/tmp/odoo.conf

envsubst < "$TEMPLATE" > "$TARGET"

exec odoo -c "$TARGET"
