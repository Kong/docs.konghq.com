---
title: kumactl install
---

Install various Kuma components.

### Synopsis

Install various Kuma components.

### Options

```
  -h, --help   help for install
```

### Options inherited from parent commands

```
      --api-timeout duration   the timeout for api calls. It includes connection time, any redirects, and reading the response body. A timeout of zero means no timeout (default 1m0s)
      --config-file string     path to the configuration file to use
      --log-level string       log level: one of off|info|debug (default "off")
      --no-config              if set no config file and config directory will be created
```

### SEE ALSO

* [kumactl](/docs/{{ page.version }}/generated/cmd/kumactl/kumactl)	 - Management tool for Kuma
* [kumactl install control-plane](/docs/{{ page.version }}/generated/cmd/kumactl/kumactl_install_control-plane)	 - Install Kuma Control Plane on Kubernetes
* [kumactl install crds](/docs/{{ page.version }}/generated/cmd/kumactl/kumactl_install_crds)	 - Install Kuma Custom Resource Definitions on Kubernetes
* [kumactl install demo](/docs/{{ page.version }}/generated/cmd/kumactl/kumactl_install_demo)	 - Install Kuma demo on Kubernetes
* [kumactl install gateway](/docs/{{ page.version }}/generated/cmd/kumactl/kumactl_install_gateway)	 - Install ingress gateway on Kubernetes
* [kumactl install logging](/docs/{{ page.version }}/generated/cmd/kumactl/kumactl_install_logging)	 - Install Logging backend in Kubernetes cluster (Loki)
* [kumactl install metrics](/docs/{{ page.version }}/generated/cmd/kumactl/kumactl_install_metrics)	 - Install Metrics backend in Kubernetes cluster (Prometheus + Grafana)
* [kumactl install observability](/docs/{{ page.version }}/generated/cmd/kumactl/kumactl_install_observability)	 - Install Observability (Metrics, Logging, Tracing) backend in Kubernetes cluster (Prometheus + Grafana + Loki + Jaeger + Zipkin)
* [kumactl install tracing](/docs/{{ page.version }}/generated/cmd/kumactl/kumactl_install_tracing)	 - Install Tracing backend in Kubernetes cluster (Jaeger)
* [kumactl install transparent-proxy](/docs/{{ page.version }}/generated/cmd/kumactl/kumactl_install_transparent-proxy)	 - Install Transparent Proxy pre-requisites on the host

