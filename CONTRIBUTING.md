Contributing

This repository is intended to be a production-grade reference for running Odoo on Kubernetes.
Contributions are welcome if they improve clarity, correctness, security, or real-world applicability.

How to Contribute
1. Fork the repository and create a feature branch.
2. Make your changes with meaningful commit messages.
3. Validate your changes locally:

make test-manifests

4. Open a Pull Request explaining:
- what problem you are solving
- why the change is useful
- how it was tested

What Good Contributions Look Like
- Improvements to Kubernetes manifests, security, or reliability
- Better documentation, diagrams, or runbooks
- Fixes that make the stack more production-ready
- Clear examples and practical enhancements

Quality Standards
Before submitting a PR, ensure:
- YAML passes yamllint
- Shell scripts pass shellcheck
- kustomize build works for all overlays (dev/stage/prod)
- No secrets or environment-specific values are committed
- The repository remains generic and reusable