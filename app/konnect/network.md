---
title: Ports and Network Requirements
no_version: true
---

## Control plane ports

The {{site.konnect_saas}} control plane uses the following port:

| Port      | Protocol  | Description |
|:----------|:----------|:------------|
| `443`    | TCP <br>HTTPS | Cluster communication port for configuration and telemetry data. The {{site.konnect_saas}} control plane uses this port to listen for runtime node connections and to communicate with the runtime nodes. |

Kong's hosted control plane expects traffic on this port, so the cluster port
can't be customized.

The cluster communication port must be accessible by all
the data planes within the same cluster.
This port is protected by mTLS to
ensure end-to-end security and integrity.

## Runtime instance ports

By default, {{site.base_gateway}} listens on the following ports:

| Port                                                                               | Protocol | Description |
|:-----------------------------------------------------------------------------------|:---------|:--|
| [`8000`](/gateway/latest/reference/configuration/#proxy_listen)      | HTTP     | Takes incoming HTTP traffic from consumers, and forwards it to upstream services. |
| [`8443`](/gateway/latest/reference/configuration/#proxy_listen)      | HTTPS    | Takes incoming HTTPS traffic from consumers, and forwards it to upstream services. |

{{site.base_gateway}} ports can be fully customized. Set them in `kong.conf`.

For Kubernetes or Docker deployments, map ports as needed. For example, if you
want to use port `3001` for the proxy, map `3001:8000`.

## Hostnames

Add the following hostnames to allowlists to give the
{{site.konnect_short_name}} control plane access through firewalls:

* `cloud.konghq.com`: The {{site.konnect_short_name}} platform.
* `us.api.konghq.com`: The {{site.konnect_short_name}} API.
    Necessary if you are using decK in your workflow, as decK uses this API to access and apply configuration.
* `<group-ID>.us.cp0.konghq.com`: Handles configuration for a runtime group.
    Runtime instances connect to this host to receive configuration updates.
* `<group-ID>.us.tp0.konghq.com`: Gathers telemetry for a runtime group.

The configuration and telemetry hostnames are unique to each organization and
runtime group.

You can find them through the Runtime Manager:

1. Open a runtime group.
2. Click **Add runtime instance**.
3. Choose the Linux or Kubernetes tab and note the hostnames in the codeblock for the following parameters:

    ```
    cluster_control_plane = example12345.us.cp0.konghq.com:443
    cluster_server_name = example12345.us.cp0.konghq.com
    cluster_telemetry_endpoint = example12345.us.tp0.konghq.com:443
    cluster_telemetry_server_name = example12345.us.tp0.konghq.com
    ```
