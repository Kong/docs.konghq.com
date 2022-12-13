---
title: Configuration
---

You configure the control plane, data plane, and CLI (kumactl) for Kuma separately. Here's what to do.

## Control plane

You can configure the control plane:
- With environment variables
- With a YAML configuration file

Environment variables take precedence over YAML configuration.

You can find all possible configuration and the default values in the [`kuma-cp` reference doc](/docs/{{ page.version }}/generated/kuma-cp).

{% tabs control-plane useUrlFragment=false %}
{% tab control-plane Kubernetes (kumactl) %}
When using `kumactl`, you can override the configuration with the `--env-var` flag. For example, to configure the refresh interval for configuration of the data plane proxy, specify:
```sh
kumactl install control-plane \
  --env-var KUMA_XDS_SERVER_DATAPLANE_CONFIGURATION_REFRESH_INTERVAL=5s \
  --env-var KUMA_XDS_SERVER_DATAPLANE_STATUS_FLUSH_INTERVAL=5s | kubectl apply -f -
```
{% endtab %}
{% tab control-plane Kubernetes (HELM) %}
When using `helm`, you can override the configuration with the `envVars` field. For example, to configure the refresh interval for configuration with the data plane proxy, specify:
```sh
helm install --version 0.7.1 \
  --set controlPlane.envVars.KUMA_XDS_SERVER_DATAPLANE_CONFIGURATION_REFRESH_INTERVAL=5s \
  --set controlPlane.envVars.KUMA_XDS_SERVER_DATAPLANE_STATUS_FLUSH_INTERVAL=5s \
  kuma kuma/kuma
```

Or you can create a `values.yaml` file with:
```yaml
controlPlane:
  envVars:
    KUMA_XDS_SERVER_DATAPLANE_CONFIGURATION_REFRESH_INTERVAL: 5s
    KUMA_XDS_SERVER_DATAPLANE_STATUS_FLUSH_INTERVAL: 5s
```
and then specify it in the helm install command:

```sh
helm install --version 0.7.1 -f values.yaml kuma kuma/kuma
```
{% endtab %}
{% tab control-plane Universal %}
First, specify your overrides in the appropriate config file, then run `kuma-cp`:

For example create a `kuma-cp.conf.overrides.yml` file with:
```yaml
xdsServer:
  dataplaneConfigurationRefreshInterval: 5s
  dataplaneStatusFlushInterval: 5s
```

Use this configuration file in the arguments:
```sh
kuma-cp run -c kuma-cp.conf.overrides.yml
```

Or you can specify environment variables:

```sh
KUMA_XDS_SERVER_DATAPLANE_CONFIGURATION_REFRESH_INTERVAL=5s \
  KUMA_XDS_SERVER_DATAPLANE_STATUS_FLUSH_INTERVAL=5s \
  kuma-cp run
```
{% endtab %}
{% endtabs %}

{% tip %}
If you configure `kuma-cp` with a YAML file, make sure to provide only values that you want to override.
Otherwise, upgrading Kuma might be harder, because you need to keep track of your changes when replacing this file on every upgrade.
{% endtip %}

### Inspecting the configuration

Configuration of `kuma-cp` is logged when `kuma-cp` runs.

You can also get the configuration with a call to the Kuma API server:
```sh
curl http://<CP_ADDRESS>:5681/config
```
It's also displayed on the Diagnostic tab in the GUI, in the lower left corner.

In a multi-zone deployment, the zone control plane sends its config to the global control plane. This lets you inspect all configurations with `kumactl inspect zones -oyaml` or in the GUI.

## Data plane proxy

{% tabs data-plane-proxy useUrlFragment=false %}
{% tab data-plane-proxy Kubernetes %}
In Kubernetes, `kuma-dp` is automatically configured and injected by Kubernetes.
The data plane proxy configuration is determined by the control plane. You can review the config details in the `runtime.kubernetes.injector.sidecarContainer` section of the `kuma-cp` config.
{% endtab %}
{% tab data-plane-proxy Universal %}
`kuma-dp` is configured with command line arguments. Run `kuma-dp run -h` to inspect all available settings.
{% endtab %}
{% endtabs %}

### Inspecting the configuration

Configuration of `kuma-dp` is logged when `kuma-dp` runs.

## kumactl

The configuration is stored in `$HOME/.kumactl/config`, which is created when you run `kumactl` for the first time.
When you add a new control plane with `kumactl config control-planes add`, the config file is updated.
To change the path of the config file, run `kumactl` with `--config-file /new-path/config`.

### Inspecting the configuration

You can view the current configuration using `kumactl config view`.
