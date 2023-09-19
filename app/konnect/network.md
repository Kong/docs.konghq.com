---
title: Ports and Network Requirements
---

## Control plane ports

The {{site.konnect_saas}} control plane uses the following ports:

| Port      | Protocol  | Description |
|:----------|:----------|:------------|
| `443`    | TCP <br>HTTPS | Cluster communication port for configuration and telemetry data. The {{site.konnect_saas}} control plane uses this port to listen for runtime node connections and to communicate with the runtime nodes. <br> The cluster communication port must be accessible by all the data planes within the same cluster. This port is protected by mTLS to ensure end-to-end security and integrity. |
| `8071`   | TCP <br> UDP | Port used for audit logging. |

Kong's hosted control plane expects traffic on these ports, so they can't be customized. 

{:.note}
> **Note**: If you are unable to make outbound connections using port `443`, you can use an existing proxy in your network to make the connection. See [Control Plane and Data Plane Communication through a Forward Proxy](/gateway/latest/production/networking/cp-dp-proxy/) for details. 

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

Depending on your Runtime Group type, you may need to add hostnames to your firewall allowlist.

{% navtabs %}
{% navtab Kong Gateway %}
Runtime instances initiate the connection to the {{site.konnect_short_name}} control plane.
They require access through firewalls to communicate with the control plane.

To let runtime instances request and receive configuration, and send telemetry data,
add the following hostnames to the firewall allowlist:

* `cloud.konghq.com`: The {{site.konnect_short_name}} platform.
* `<region>.api.konghq.com`: The {{site.konnect_short_name}} API.
  Necessary if you are using decK in your workflow, decK uses this API to access and apply configurations.
  Region can be `us`, `eu`, or `global`.
* `<runtime-group-id>.<region>.cp0.konghq.com`: Handles configuration for a runtime group.
  Runtime instances connect to this host to receive configuration updates.
  This hostname is unique to each organization and runtime group.
* `<runtime-group-id>.<region>.tp0.konghq.com`: Gathers telemetry data for a runtime group.
  This hostname is unique to each organization and runtime group.

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
{% endnavtab %}

{% navtab Kong Ingress Controller %}

{{site.kic_product_name}} initiates the connection to the {{site.konnect_short_name}} [Runtime Configuration API](/konnect/api/runtime-groups-config/) to:

* Synchronize the configuration of the {{site.base_gateway}} instances with {{site.konnect_short_name}}
* Register runtime instances
* Fetch license information

Runtime instances initiate the connection to {{site.konnect_short_name}} APIs to report Analytics data.

The following hostnames must be allowed through firewalls to enable these connections:

* `cloud.konghq.com`: The {{site.konnect_short_name}} platform.
* `<region>.api.konghq.com`: The {{site.konnect_short_name}} API.
* `<runtime-group-id>.<region>.tp0.konghq.com`: Telemetry endpoint for a runtime group, required for Analytics.
  This hostname is unique to each organization and runtime group. 

You can find the Telemetry hostname through the Runtime Manager:

1. Open a runtime group.
2. Click **Runtime group actions** > **View Connection Instructions**.
3. Look for the following parameter in the `Install the KIC` section: 

    ```
    cluster_telemetry_endpoint: "example.us.tp0.konghq.com:443"
    ```
{% endnavtab %}
{% endnavtabs %}

{:.note}
> **Note**: Visit [https://ip-addresses.origin.konghq.com/ip-addresses.json](https://ip-addresses.origin.konghq.com/ip-addresses.json) for the list of IPs associated to regional hostnames. You can also subscribe to [https://ip-addresses.origin.konghq.com/rss](https://ip-addresses.origin.konghq.com/rss) for updates.  
