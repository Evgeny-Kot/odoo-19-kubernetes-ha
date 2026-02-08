Architecture — Odoo 19 Enterprise on Kubernetes (HA / Clustered)

---

This document describes the architectural decisions behind running Odoo 19 Enterprise
in high-availability clustered mode on Kubernetes using modern platform engineering practices.

The goal is not simply to containerize Odoo, but to design a reliable, scalable,
and secure platform for a stateful business critical application.

---

Core Components
Gateway API
Public entry point with TLS termination and path-based routing rules.
oauth2-proxy
OIDC authentication layer protecting Odoo database management endpoints.
Odoo 19 Enterprise
Stateless application layer running 2+ replicas with a shared RWX filestore
and immutable baked in addons.
Redis
Cache, session, and bus backend required for proper multi replica behavior.
CrunchyData PostgreSQL
Highly available PostgreSQL with replication and pgBackRest backups.
PgBouncer (optional)
Connection pooling layer for environments with high concurrency.
Vault + External Secrets
Single source of truth for secrets, synchronized into Kubernetes at runtime.

---

HA and Scaling Model
Odoo is designed to scale horizontally.
- Multiple replicas behind the Gateway API
- Readiness probes ensure traffic is only sent to healthy pods
- Horizontal Pod Autoscaler scales based on CPU and memory
Worker formula baseline:
workers = (2 × CPU cores) + 1
This is adjusted based on workload characteristics.
The filestore is hosted on an RWX volume (NFS, Longhorn RWX, Portworx, etc.).
Addons are NOT shared — they are part of the container image.
Redis runs as a StatefulSet (or may be external).
PostgreSQL high availability is handled by CrunchyData.
Failure Modes and Behavior
Odoo pod crash
Traffic is routed to remaining pods automatically.
Redis outage
Cache and sessions are lost; Odoo continues operating in degraded mode.
Postgres primary failover
Handled automatically by CrunchyData; Odoo reconnects.
Gateway outage
External traffic is blocked but internal services remain healthy.
Vault outage
No new secret synchronization, but existing Kubernetes Secrets continue to function.
Networking and Routing
Gateway API routing rules:
/ → Odoo service
/longpolling and /websocket → Odoo service with extended timeouts
/web/database/manager → oauth2-proxy → Odoo
This separation prevents accidental exposure of sensitive Odoo endpoints.
Security Controls
- Containers run as non-root
- seccomp profile RuntimeDefault
- Read-only root filesystem where possible
- NetworkPolicies strictly limit pod communication
- Vault is the only source of secrets
Data and Storage
RWX filestore is used for Odoo attachments and user files.
PostgreSQL persistent volumes are fully managed by CrunchyData.
Addons are part of the Docker image to guarantee identical code on every replica.
Immutable Addons Rationale
Clustered Odoo requires strict code consistency across replicas.
Baking addons into the image:
- prevents version drift between pods
- allows deterministic rollbacks by image tag
- removes the need for shared addon volumes
- removes runtime synchronization or init container logic
Observability (Recommended)
For production environments, the following stack is recommended:
- Prometheus and Grafana for metrics
- Loki or ELK for logs
- OpenTelemetry for tracing
Summary
This architecture demonstrates how to run Odoo on Kubernetes as a proper
platform workload with high availability, strong security controls,
and reproducible infrastructure practices.