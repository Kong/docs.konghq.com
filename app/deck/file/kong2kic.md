---
title: kong2kic
---

The `kong2kic` command converts a {{ site.base_gateway }} declarative configuration file in to Kubernetes CRDs that can be used with the [{{ site.kic_product_name }}](/kubernetes-ingress-controller/latest/).

`kong2kic` generates Gateway API `HTTPRoute` resources by default. If you're using `ingress` resources, you can specify the `--ingress` flag.

Consumers, Consumer Groups, Plugins, and other supported Kong entities are converted to the related `Kong` prefixed resources, such as `KongConsumer`.

```bash
deck file kong2kic -s kong.yaml -o k8s.yaml
```

## Configuration options

The table below shows the most commonly used configuration options. For a complete list, run `deck file kong2kic --help`.

| Flag | Description | Default |
|------|-------------|---------|
| `--class-name` | Value to use for `"kubernetes.io/ingress.class"` (ingress) and for `"parentRefs.name"` (HTTPRoute). | `kong` |
| `--format` | Output file format: `json` or `yaml`. | `yaml` |
| `--ingress` | Use Kubernetes Ingress API manifests instead of Gateway API manifests. | N/A |
| `--kic-version` | Generate manifests for KIC v3 or v2. Possible values are 2 or 3. | `3` |