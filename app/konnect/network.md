---
title: Ports and Network Requirements
---

## Control plane ports

The {{site.konnect_saas}} control plane uses the following ports:

| Port      | Protocol  | Description |
|:----------|:----------|:------------|
| `443`    | TCP <br>HTTPS | Cluster communication port for configuration and telemetry data. The {{site.konnect_saas}} control plane uses this port to listen for connections and communicate with data plane nodes. <br> The cluster communication port must be accessible to data plane nodes within the same cluster. This port is protected by mTLS to ensure end-to-end security and integrity. |
| `8071`   | TCP <br> UDP | Port used for audit logging. |

Kong's hosted control plane expects traffic on these ports, so they can't be customized. 

{:.note}
> **Note**: If you are unable to make outbound connections using port `443`, you can use an existing proxy in your network to make the connection. See [Control Plane and Data Plane Communication through a Forward Proxy](/gateway/latest/production/networking/cp-dp-proxy/) for details. 

## Data plane node ports

By default, {{site.base_gateway}} listens on the following ports:

| Port                                                                               | Protocol | Description |
|:-----------------------------------------------------------------------------------|:---------|:--|
| [`8000`](/gateway/latest/reference/configuration/#proxy_listen)      | HTTP     | Takes incoming HTTP traffic from consumers, and forwards it to upstream services. |
| [`8443`](/gateway/latest/reference/configuration/#proxy_listen)      | HTTPS    | Takes incoming HTTPS traffic from consumers, and forwards it to upstream services. |

{{site.base_gateway}} ports can be fully customized. Set them in `kong.conf`.

For Kubernetes or Docker deployments, map ports as needed. For example, if you
want to use port `3001` for the proxy, map `3001:8000`.

## Hostnames
### Control planes

Depending on your control plane type, you may need to add hostnames to your firewall allowlist.

{% navtabs %}
{% navtab Kong Gateway %}
Data plane nodes initiate the connection to the {{site.konnect_short_name}} control plane.
They require access through firewalls to communicate with the control plane.

To let a data plane node request and receive configuration, and send telemetry data,
add the following hostnames to the firewall allowlist:

* `cloud.konghq.com`: The {{site.konnect_short_name}} platform.
* `<region>.api.konghq.com`: The {{site.konnect_short_name}} API.
  Necessary if you are using decK in your workflow, decK uses this API to access and apply configurations.
  Region can be `us`, `eu`, or `global`.
* `<controlPlaneId>.<region>.cp0.konghq.com`: Handles configuration for a control plane.
  Data plane nodes connect to this host to receive configuration updates.
  This hostname is unique to each organization and control plane.
* `<controlPlaneId>.<region>.tp0.konghq.com`: Gathers telemetry data for a control plane.
  This hostname is unique to each organization and control plane.

You can find the configuration and telemetry hostnames through the Gateway Manager:

1. Open a control plane.
2. Select **Data Plane Nodes** from the side menu, then click the **New Data Plane Node** button.
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

{{site.kic_product_name}} initiates the connection to the {{site.konnect_short_name}} [Control Planes Configuration API](/konnect/api/control-plane-configuration/latest/) to:

* Synchronize the configuration of the {{site.base_gateway}} instances with {{site.konnect_short_name}}
* Register data plane nodes
* Fetch license information

Data plane nodes initiate the connection to {{site.konnect_short_name}} APIs to report Analytics data.

The following hostnames must be allowed through firewalls to enable these connections:

* `cloud.konghq.com`: The {{site.konnect_short_name}} platform.
* `<region>.api.konghq.com`: The {{site.konnect_short_name}} API.
* `<controlPlaneId>.<region>.tp0.konghq.com`: Telemetry endpoint for a control plane, required for Analytics.
  This hostname is unique to each organization and control plane. 

You can find the Telemetry hostname through the Gateway Manager:

1. Open a control plane.
2. Click {% konnect_icon cogwheel %} **Control Plane Actions** > **View Connection Instructions**.
3. Look for the following parameter in the `Install the KIC` section: 

    ```
    cluster_telemetry_endpoint: "example.us.tp0.konghq.com:443"
    ```
{% endnavtab %}
{% endnavtabs %}

{:.note}
> **Note**: Visit [https://ip-addresses.origin.konghq.com/ip-addresses.json](https://ip-addresses.origin.konghq.com/ip-addresses.json) for the list of IPs associated to regional hostnames. You can also subscribe to [https://ip-addresses.origin.konghq.com/rss](https://ip-addresses.origin.konghq.com/rss) for updates. 

### Mesh Manager

If you plan to use [Mesh Manager](/konnect/mesh-manager/) to manage your Kong service mesh, you must add the `<region>.mesh.sync.konghq.com:443` hostname to your firewall allowlist. The region can be `us`, `eu`, or `global`.
