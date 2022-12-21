---
title: Control Plane Configuration
---

## Modifying the configuration

There are 2 ways to configure the control plane:
- Environment variables
- YAML configuration file

Environment variables take precedence over YAML configuration.

All possible configuration and their default values are in the [`kuma-cp` reference doc](/docs/{{ page.version }}/generated/kuma-cp).

{% tip %}
Environment variables usually match the yaml path by replacing `.` with `_`, capitalizing names and prefixing with KUMA.

For example the yaml path: `store.postgres.port` is the environment variable: `KUMA_STORE_POSTGRES_PORT`.
{% endtip %}

{% tabs usage useUrlFragment=false %}
{% tab usage Kubernetes (kumactl) %}
When using `kumactl`, override the configuration with the `--env-var` flag. For example, to configure the refresh interval for configuration of the data plane proxy, specify:
```sh
kumactl install control plane \
  --env-var KUMA_XDS_SERVER_DATAPLANE_CONFIGURATION_REFRESH_INTERVAL=5s \
  --env-var KUMA_XDS_SERVER_DATAPLANE_STATUS_FLUSH_INTERVAL=5s | kubectl apply -f -
```
{% endtab %}
{% tab usage Kubernetes (HELM) %}
When using `helm`, you can override the configuration with the `envVars` field. For example, to configure the refresh interval for configuration with the data plane proxy, specify:
```sh
helm install \
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
helm install -f values.yaml kuma kuma/kuma
```

If you have a lot of configuration you can just write them all in a YAML file and use:

```shell
helm install kuma kuma/kuma --set-file controlPlace.config=cp-conf.yaml
```
The value of the configmap `kuma-control-plane-config` is now the content of `cp-conf.yaml`.

{% endtab %}
{% tab usage Universal %}
First, specify your configuration in the appropriate config file, then run `kuma-cp`:

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
Otherwise, upgrading {{site.mesh_product_name}} might be harder, because you need to keep track of your changes when replacing this file on every upgrade.
{% endtip %}

## Inspecting the configuration

There are many ways to see your control plane configuration:

- In the `kuma-cp` logs, the configuration is logged on startup.
- The control plane API server has an endpoint: `http://<CP_ADDRESS>:5681/config`
- The GUI exposes the configuration on the Diagnostic tab, accessible in the lower left corner.
- In a multi-zone deployment, the zone control plane sends its configuration to the global control plane. This lets you inspect all configurations with `kumactl inspect zones -oyaml` or in the GUI.

## Store

As explained in the [Overview](/docs/{{ page.version }}/documentation/introduction), when {{site.mesh_product_name}} (`kuma-cp`) is up and running it needs to store its state somewhere.
Thus state includes the policies configured, the data plane proxy status, and so on.

{{site.mesh_product_name}} supports a few different types of store.
You can configure the backend storage by setting the `KUMA_STORE_TYPE` environment variable when running the control plane.

The following backends are available:

- memory
- kubernetes
- postgres

The configuration to set the store is the yaml path `store.type` or the environment variable `KUMA_STORE_TYPE`.

### Kubernetes

{{site.mesh_product_name}} stores all the state in the underlying Kubernetes cluster.

This is only usable if the control plane is running in Kubernetes mode. You can't manage Universal CPPs from a control plane with a Kubernetes store.

### Memory

{{site.mesh_product_name}} stores all the state in-memory. Restarting {{site.mesh_product_name}} will delete all the data, and you cannot have more than one control plane instance running.

Memory is the **default** memory store when running in Universal mode and is only available in Universal mode.


{% warning %}
Because the state is not persisted this store should only be used when trying things out.
{% endwarning %}

### Postgres

{{site.mesh_product_name}} stores all the state in a PostgreSQL database. This can only be used when running in Universal mode.

```sh
KUMA_STORE_TYPE=postgres \
  KUMA_STORE_POSTGRES_HOST=localhost \
  KUMA_STORE_POSTGRES_PORT=5432 \
  KUMA_STORE_POSTGRES_USER=kuma-user \
  KUMA_STORE_POSTGRES_PASSWORD=kuma-password \
  KUMA_STORE_POSTGRES_DB_NAME=kuma \
  kuma-cp run
```

{% tip %}
For great availability and low maintenance cost you can use a PostgreSQL database offered by any cloud vendor.
{% endtip %}

#### TLS

Connection between Postgres and {{site.mesh_product_name}} CP should be secured with TLS.

The following modes are available to secure the connection to Postgres:

* `disable`: the connection is not secured with TLS (secrets will be transmitted over network in plain text).
* `verifyNone`: the connection is secured but neither hostname, nor by which CA the certificate is signed is checked.
* `verifyCa`: the connection is secured and the certificate presented by the server is verified using the provided CA.
* `verifyFull`: the connection is secured, certificate presented by the server is verified using the provided CA and server hostname must match the one in the certificate.


The mode is configured with the `KUMA_STORE_POSTGRES_TLS_MODE` environment variable.
The CA used to verify the server's certificate is configured with the `KUMA_STORE_POSTGRES_TLS_CA_PATH` environment variable.

After configuring the above security settings in {{site.mesh_product_name}}, we also have to configure Postgres' [`pg_hba.conf`](https://www.postgresql.org/docs/9.1/auth-pg-hba-conf.html) file to restrict unsecured connections.

Here is an example configuration that allows only TLS connections and requires a username and password:
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD
hostssl all             all             0.0.0.0/0               password
```

You can also provide a client key and certificate for mTLS using the `KUMA_STORE_POSTGRES_TLS_CERT_PATH` and `KUMA_STORE_POSTGRES_TLS_KEY_PATH` variables.
This pair can be used in conjunction with the `cert` auth-method described [in the Postgres documentation](https://www.postgresql.org/docs/9.1/auth-pg-hba-conf.html).

#### Migrations

To provide easy upgrades between {{site.mesh_product_name}} versions there is a migration system for the Postgres DB schema.

When upgrading to a new version of {{site.mesh_product_name}}, run `kuma-cp migrate up` so the new schema is applied.
```sh
KUMA_STORE_TYPE=postgres \
  KUMA_STORE_POSTGRES_HOST=localhost \
  KUMA_STORE_POSTGRES_PORT=5432 \
  KUMA_STORE_POSTGRES_USER=kuma-user \
  KUMA_STORE_POSTGRES_PASSWORD=kuma-password \
  KUMA_STORE_POSTGRES_DB_NAME=kuma \
  kuma-cp migrate up
```

{{site.mesh_product_name}} CP at the start checks if the current DB schema is compatible with the version of {{site.mesh_product_name}} you are trying to run.
Information about the latest migration is stored in `schema_migration` table.
