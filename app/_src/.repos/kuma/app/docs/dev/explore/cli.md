---
title: CLI
---

{{site.mesh_product_name}} ships in a bundle that includes a few executables:

* `kuma-cp`: this is the main {{site.mesh_product_name}} executable that runs the control plane (CP).
* `kuma-dp`: this is the {{site.mesh_product_name}} data plane proxy executable that - under the hood - invokes `envoy`.
* `envoy`: this is the Envoy executable that we bundle for convenience into the archive.
* `kumactl`: this is the the user CLI to interact with {{site.mesh_product_name}} (`kuma-cp`) and its data.
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

The `kumactl` executable is a very important component in your journey with {{site.mesh_product_name}}. It allows to:

* Retrieve the state of {{site.mesh_product_name}} and the configured [policies](/docs/{{ page.version }}/policies/introduction) in every environment.
* On **Universal** environments, it allows to change the state of {{site.mesh_product_name}} by applying new policies with the `kumactl apply [..]` command.
* On **Kubernetes** it is **read-only**, because you are supposed to change the state of {{site.mesh_product_name}} by leveraging {{site.mesh_product_name}}'s CRDs.
* It provides helpers to install {{site.mesh_product_name}} on Kubernetes, and to configure the PostgreSQL schema on Universal (`kumactl install [..]`).

{% tip %}
The `kumactl` application is a CLI client for the underlying [HTTP API](/docs/{{ page.version }}/reference/http-api) of {{site.mesh_product_name}}. Therefore, you can access the state of {{site.mesh_product_name}} by leveraging with the API directly. On Universal you will be able to also make changes via the HTTP API, while on Kubernetes the HTTP API is read-only.
{% endtip %}

Available commands on `kumactl` are:

* `kumactl install [..]`: provides helpers to install {{site.mesh_product_name}} components in Kubernetes.
  * `kumactl install control-plane`: Installs {{site.mesh_product_name}} in Kubernetes in a `kuma-system` namespace.
  * `kumactl install observability`: Install Observability (Metrics, Logging, Tracing) backend in Kubernetes cluster (Prometheus + Grafana + Loki + Jaeger + Zipkin) in `mesh-observability` namespace.
* `kumactl config [..]`: configures the local or zone control-planes that `kumactl` should talk to. You can have more than one enabled, and the configuration will be stored in `~/.kumactl/config`.
* `kumactl apply [..]`: used to change the state of {{site.mesh_product_name}}. Only available on Universal.
* `kumactl get [..]`: used to retrieve the raw state of entities {{site.mesh_product_name}}.
* `kumactl inspect [..]`: used to retrieve an augmented state of entities in {{site.mesh_product_name}}.
* `kumactl generate dataplane-token`: used to generate [Dataplane Token](/docs/{{ page.version }}/security/dp-auth/#data-plane-proxy-token).
* `kumactl generate tls-certificate`: used to generate a TLS certificate for client or server.
* `kumactl manage ca [..]`: used to manage certificate authorities.
* `kumactl help [..]`: help dialog that explains the commands available.
* `kumactl version [--detailed]`: shows the version of the program.

Checkout the [`kumactl` usage docs](/docs/{{ page.version }}/generated/cmd/kumactl/kumactl) for full documentation.

### Using variables

When using `kumactl apply` you can specify variables to use your yaml as a template.
This is useful for parametrizing policies and specifying values at runtime.

For example with a yaml like:

```yaml
type: Mesh
name: default
mtls:
  backends:
  - name: vault-1
    type: {{ caType }}
    dpCert:
      rotation:
        expiration: 10h
```

You can then set the `caType` when applying it:

```sh
kumactl apply -f ~/res/mesh.yaml -v caType=builtin
```

This will create this mesh:

```yaml
type: Mesh
name: default
mtls:
  backends:
    - name: vault-1
      type: builtin
      dpCert:
        rotation:
          expiration: 10h
```

### Configuration

You can view the current configuration using `kumactl config view`.

The configuration is stored in `$HOME/.kumactl/config`, which is created when you run `kumactl` for the first time.
When you add a new control plane with `kumactl config control-planes add`, the config file is updated.
To change the path of the config file, run `kumactl` with `--config-file /new-path/config`.
