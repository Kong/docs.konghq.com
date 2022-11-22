---
title: Ports and Network Requirements
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

Runtime instances initiate the connection to the {{site.konnect_short_name}} control plane. 
They require access through firewalls to communicate with the control plane.

To let a runtime instances request and receive configuration, and send telemetry data, 
add the following hostnames to the firewall allowlist (depending on the [geographic regions](/konnect/regions) you use).

### US region

| Hostname      | Description |
|:----------|:----------|
| `cloud.konghq.com`    | The {{site.konnect_short_name}} platform. |
| `global.api.konghq.com` | The {{site.konnect_short_name}} API for platform authentication, identity, permissions, teams, and organizational entitlements and settings. |
| `us.api.konghq.com` | The {{site.konnect_short_name}} API for the US region. Necessary if you are using decK in your workflow, decK uses this API to access and apply configurations. |
| `PORTAL_ID.us.portal.konghq.com` | The URL for the Dev Portal in the US region. |
| `RUNTIME_GROUP_ID.us.cp0.konghq.com` | Handles configuration for a runtime group in the US region. Runtime instances connect to this host to receive configuration updates. This hostname is unique to each organization and runtime group. |
| `RUNTIME_GROUP_ID.us.tp0.konghq.com` | Gathers telemetry data for a runtime group in the US region. This hostname is unique to each organization and runtime group. |


### EU region

| Hostname      | Description |
|:----------|:----------|
| `cloud.konghq.com`    | The {{site.konnect_short_name}} platform. |
| `global.api.konghq.com` | The {{site.konnect_short_name}} API for platform authentication, identity, permissions, teams, and organizational entitlements and settings. |
| `eu.api.konghq.com` | The {{site.konnect_short_name}} API for the EU region. Necessary if you are using decK in your workflow, decK uses this API to access and apply configurations. |
| `PORTAL_ID.eu.portal.konghq.com` | The URL for the Dev Portal in the EU region. |
| `RUNTIME_GROUP_ID.eu.cp0.konghq.com` | Handles configuration for a runtime group in the EU region. Runtime instances connect to this host to receive configuration updates. This hostname is unique to each organization and runtime group. |
| `RUNTIME_GROUP_ID.eu.tp0.konghq.com` | Gathers telemetry data for a runtime group in the EU region. This hostname is unique to each organization and runtime group. |

### Find configuration and telemetry hostnames

You can find the configuration and telemetry hostnames through the Runtime Manager:

1. Open a runtime group.
2. Click **Add runtime instance**.
3. Choose the Linux or Kubernetes tab and note the hostnames in the code block
for the following parameters:

    ```
    cluster_control_plane = example.us.cp0.konghq.com:443
    cluster_server_name = example.us.cp0.konghq.com
    cluster_telemetry_endpoint = example.us.tp0.konghq.com:443
    cluster_telemetry_server_name = example.us.tp0.konghq.com
    ```

{:.note}
> **Note**: Visit [https://ip-addresses.origin.konghq.com/ip-addresses.json](https://ip-addresses.origin.konghq.com/ip-addresses.json) for the list of IPs associated to regional hostnames. You can also subscribe to [https://ip-addresses.origin.konghq.com/rss](https://ip-addresses.origin.konghq.com/rss) for updates.  
