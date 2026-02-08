# Performance Tuning

## Workers
Baseline: $\text{workers} = (2 \times CPU) + 1$

## Memory
- Increase memory to prevent Odoo worker recycling.
- Set `limit_memory_hard` and `limit_memory_soft`.

## Probes
- Use startup probe to avoid false restarts.
- Readiness probe should validate HTTP 200.
