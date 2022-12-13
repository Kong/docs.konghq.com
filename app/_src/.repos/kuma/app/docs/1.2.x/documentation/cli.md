---
title: CLI
---

Kuma ships in a bundle that includes a few executables:

* `kuma-cp`: this is the main Kuma executable that runs the control plane (CP).
* `kuma-dp`: this is the Kuma data plane proxy executable that - under the hood - invokes `envoy`.
* `envoy`: this is the Envoy executable that we bundle for convenience into the archive.
* `kumactl`: this is the the user CLI to interact with Kuma (`kuma-cp`) and its data.
* `kuma-prometheus-sd`: this is a helper tool that enables native integration between `Kuma` and `Prometheus`. Thanks to it, `Prometheus` will be able to automatically find all dataplanes in your Mesh and scrape metrics out of them.
* `kuma-tcp-echo`: this is a sample application that echos back the requests we are making, used for demo purposes.

According to the [installation instructions](/install/), some of these executables are automatically executed as part of the installation workflow, while some other times you will have to execute them directly.

You can check the usage of the executables by running the `-h` flag, like:

```sh
kuma-cp -h
```

and you can check their version by running the `version [--detailed]` command like:

```sh
kuma-cp version --detailed
```

## kumactl

The `kumactl` executable is a very important component in your journey with Kuma. It allows to:

* Retrieve the state of Kuma and the configured [policies](/docs/{{ page.version }}/policies/introduction) in every environment.
* On **Universal** environments, it allows to change the state of Kuma by applying new policies with the `kumactl apply [..]` command.
* On **Kubernetes** it is **read-only**, because you are supposed to change the state of Kuma by leveraging Kuma's CRDs.
* It provides helpers to install Kuma on Kubernetes, and to configure the PostgreSQL schema on Universal (`kumactl install [..]`).

{% tip %}
The `kumactl` application is a CLI client for the underlying [HTTP API](/docs/{{ page.version }}/documentation/http-api) of Kuma. Therefore, you can access the state of Kuma by leveraging with the API directly. On Universal you will be able to also make changes via the HTTP API, while on Kubernetes the HTTP API is read-only.
{% endtip %}

Available commands on `kumactl` are:

* `kumactl install [..]`: provides helpers to install Kuma components in Kubernetes.
  * `kumactl install control-plane`: Installs Kuma in Kubernetes in a `kuma-system` namespace.
  * `kumactl install metrics`: Installs Prometheus + Grafana in Kubernetes in a `kuma-metrics` namespace.
  * `kumactl install tracing`: Installs Jaeger with Zipkin compatibility in Kubernetes in a `kuma-tracing` namespace.
* `kumactl config [..]`: configures the local or zone control-planes that `kumactl` should talk to. You can have more than one enabled, and the configuration will be stored in `~/.kumactl/config`.
* `kumactl apply [..]`: used to change the state of Kuma. Only available on Universal.
* `kumactl get [..]`: used to retrieve the raw state of entities Kuma.
* `kumactl inspect [..]`: used to retrieve an augmented state of entities in Kuma.
* `kumactl generate dataplane-token`: used to generate [Dataplane Token](/docs/{{ page.version }}/documentation/security/#dataplane-token).
* `kumactl generate tls-certificate`: used to generate a TLS certificate for client or server.
* `kumactl manage ca [..]`: used to manage certificate authorities.
* `kumactl help [..]`: help dialog that explains the commands available.
* `kumactl version [--detailed]`: shows the version of the program.