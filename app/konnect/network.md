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

## {{site.base_gateway}} hostnames

Data plane nodes initiate the connection to the {{site.konnect_short_name}} control plane.
They require access through firewalls to communicate with the control plane.

To let a data plane node request and receive configuration, and send telemetry data,
add the following hostnames to the firewall allowlist (depending on the [geographic regions](/konnect/geo) you use).

### AU geo

| Hostname      | Description |
|:----------|:----------|
| `cloud.konghq.com`    | The {{site.konnect_short_name}} platform. |
| `global.api.konghq.com` | The {{site.konnect_short_name}} API for platform authentication, identity, permissions, teams, and organizational entitlements and settings. |
| `au.api.konghq.com` | The {{site.konnect_short_name}} API for the AU geo. Necessary if you are using decK in your workflow, decK uses this API to access and apply configurations. |
| `PORTAL_ID.au.portal.konghq.com` | The URL for the Dev Portal in the AU geo. |
| `CONTROL_PLANE_ID.au.cp0.konghq.com` | Handles configuration for a control plane in the AU geo. Data plane nodes connect to this host to receive configuration updates. This hostname is unique to each organization and control plane. |
| `CONTROL_PLANE_ID.au.tp0.konghq.com` | Gathers telemetry data for a control plane in the AU geo. This hostname is unique to each organization and control plane. |

### EU geo

| Hostname      | Description |
|:----------|:----------|
| `cloud.konghq.com`    | The {{site.konnect_short_name}} platform. |
| `global.api.konghq.com` | The {{site.konnect_short_name}} API for platform authentication, identity, permissions, teams, and organizational entitlements and settings. |
| `eu.api.konghq.com` | The {{site.konnect_short_name}} API for the EU geo. Necessary if you are using decK in your workflow, decK uses this API to access and apply configurations. |
| `PORTAL_ID.eu.portal.konghq.com` | The URL for the Dev Portal in the EU geo. |
| `CONTROL_PLANE_ID.eu.cp0.konghq.com` | Handles configuration for a control plane in the EU geo. Data plane nodes connect to this host to receive configuration updates. This hostname is unique to each organization and control plane. |
| `CONTROL_PLANE_ID.eu.tp0.konghq.com` | Gathers telemetry data for a control plane in the EU geo. This hostname is unique to each organization and control plane. |

### US geo

| Hostname      | Description |
|:----------|:----------|
| `cloud.konghq.com`    | The {{site.konnect_short_name}} platform. |
| `global.api.konghq.com` | The {{site.konnect_short_name}} API for platform authentication, identity, permissions, teams, and organizational entitlements and settings. |
| `us.api.konghq.com` | The {{site.konnect_short_name}} API for the US geo. Necessary if you are using decK in your workflow, decK uses this API to access and apply configurations. |
| `PORTAL_ID.us.portal.konghq.com` | The URL for the Dev Portal in the US geo. |
| `CONTROL_PLANE_ID.us.cp0.konghq.com` | Handles configuration for a control plane in the US geo. Data plane nodes connect to this host to receive configuration updates. This hostname is unique to each organization and control plane. |
| `CONTROL_PLANE_ID.us.tp0.konghq.com` | Gathers telemetry data for a control plane in the US geo. This hostname is unique to each organization and control plane. |

### Find configuration and telemetry hostnames

You can find the configuration and telemetry hostnames through the Gateway Manager or the {{site.konnect_short_name}}
Control Planes API:

{% navtabs %}
{% navtab Gateway Manager %}

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
{% navtab Control Planes API %}
1. Send a GET request to the `control-planes` API and inspect the response:

    ```sh
    curl -X GET https://us.api.konghq.com/v2/control-planes/{controlPlaneId}  \
    --header 'Authorization: Bearer <token>'
    ```

    {:.note}
    > **Tip**: You can find your control plane's API URL on its overview page in the Gateway Manager.

2. In the response, find your `control_plane_endpoint` and the `telemetry_endpoint`:
    ```json
    {
        "config": {
            "auth_type": "pinned_client_certs",
            "cloud_gateway": false,
            "cluster_type": "CLUSTER_TYPE_CONTROL_PLANE",
            "control_plane_endpoint": "https://example.us.cp0.konghq.com",
            "proxy_urls": [],
            "telemetry_endpoint": "https://example.us.tp0.konghq.com"
        },
        "created_at": "2024-07-24T22:43:31.705Z",
        "description": "",
        "id": "8f0daba0-2246-48fb-8d56-a47ab94saf78",
        "labels": {},
        "name": "Example CP",
        "updated_at": "2024-07-24T22:43:31.705Z"
    }
    ```
{% endnavtab %}
{% endnavtabs %}

## {{site.kic_product_name}} hostnames

{{site.kic_product_name}} initiates the connection to the {{site.konnect_short_name}} [Control Planes Configuration API](/konnect/api/control-plane-configuration/latest/) to:

* Synchronize the configuration of the {{site.base_gateway}} instances with {{site.konnect_short_name}}
* Register data plane nodes
* Fetch license information

Data plane nodes initiate the connection to {{site.konnect_short_name}} APIs to report Analytics data.

Add the following hostnames to the firewall allowlist (depending on the [geographic regions](/konnect/geo) you use).

### AU geo

| Hostname      | Description |
|:----------|:----------|
| `cloud.konghq.com`    | The {{site.konnect_short_name}} platform. |
| `global.api.konghq.com` | The {{site.konnect_short_name}} API for platform authentication, identity, permissions, teams, and organizational entitlements and settings. |
| `au.api.konghq.com` | The {{site.konnect_short_name}} API for the AU geo. Necessary if you are using decK in your workflow, decK uses this API to access and apply configurations. |
| `PORTAL_ID.au.portal.konghq.com` | The URL for the Dev Portal in the AU geo. |
| `CONTROL_PLANE_ID.au.cp0.konghq.com` | Handles configuration for a control plane in the AU geo. Data plane nodes connect to this host to receive configuration updates. This hostname is unique to each organization and control plane. |
| `CONTROL_PLANE_ID.au.tp0.konghq.com` | Gathers telemetry data for a control plane in the AU geo. This hostname is unique to each organization and control plane. |

### EU geo

| Hostname      | Description |
|:----------|:----------|
| `cloud.konghq.com`    | The {{site.konnect_short_name}} platform. |
| `global.api.konghq.com` | The {{site.konnect_short_name}} API for platform authentication, identity, permissions, teams, and organizational entitlements and settings. |
| `eu.api.konghq.com` | The {{site.konnect_short_name}} API for the EU geo. Necessary if you are using decK in your workflow, decK uses this API to access and apply configurations. |
| `PORTAL_ID.eu.portal.konghq.com` | The URL for the Dev Portal in the EU geo. |
| `CONTROL_PLANE_ID.eu.cp0.konghq.com` | Handles configuration for a control plane in the EU geo. Data plane nodes connect to this host to receive configuration updates. This hostname is unique to each organization and control plane. |
| `CONTROL_PLANE_ID.eu.tp0.konghq.com` | Gathers telemetry data for a control plane in the EU geo. This hostname is unique to each organization and control plane. |

### US geo

| Hostname      | Description |
|:----------|:----------|
| `cloud.konghq.com`    | The {{site.konnect_short_name}} platform. |
| `global.api.konghq.com` | The {{site.konnect_short_name}} API for platform authentication, identity, permissions, teams, and organizational entitlements and settings. |
| `us.api.konghq.com` | The {{site.konnect_short_name}} API for the US geo. Necessary if you are using decK in your workflow, decK uses this API to access and apply configurations. |
| `PORTAL_ID.us.portal.konghq.com` | The URL for the Dev Portal in the US geo. |
| `CONTROL_PLANE_ID.us.cp0.konghq.com` | Handles configuration for a control plane in the US geo. Data plane nodes connect to this host to receive configuration updates. This hostname is unique to each organization and control plane. |
| `CONTROL_PLANE_ID.us.tp0.konghq.com` | Gathers telemetry data for a control plane in the US geo. This hostname is unique to each organization and control plane. |

### Find configuration and telemetry hostnames

{% navtabs %}
{% navtab Gateway Manager %}

You can find the telemetry hostname through the Gateway Manager:

1. Open a control plane.
2. Click {% konnect_icon cogwheel %} **Control Plane Actions** > **View Connection Instructions**.
3. Look for the following parameter in the `Install the KIC` section: 

    ```
    cluster_telemetry_endpoint: "example.us.tp0.konghq.com:443"
    ```

{% endnavtab %}
{% navtab Control Planes API %}

You can find the control plane and telemetry hostnames through the Control Planes API.

1. Send a GET request to the `control-planes` API and inspect the response:

    ```sh
    curl -X GET https://us.api.konghq.com/v2/control-planes/{controlPlaneId}  \
    --header 'Authorization: Bearer <token>'
    ```

    {:.note}
    > **Tip**: You can find your control plane's API URL on its overview page in the Gateway Manager.

2. In the response, find your `control_plane_endpoint` and the `telemetry_endpoint`:
    ```json
    {
        "config": {
            "auth_type": "pinned_client_certs",
            "cloud_gateway": false,
            "cluster_type": "CLUSTER_TYPE_K8S_INGRESS_CONTROLLER",
            "control_plane_endpoint": "https://example.us.cp0.konghq.com",
            "telemetry_endpoint": "https://example.us.tp0.konghq.com"
        },
        "created_at": "2023-03-17T16:54:48.905Z",
        "description": "",
        "id": "32bf6188-906c-483c-b9e3-d7838a089364",
        "labels": {},
        "name": "KIC CP",
        "updated_at": "2024-07-09T07:47:34.514Z"
    }
    ```
{% endnavtab %}
{% endnavtabs %}

{:.note}
> **Note**: Visit [https://ip-addresses.origin.konghq.com/ip-addresses.json](https://ip-addresses.origin.konghq.com/ip-addresses.json) for the list of IPs associated to regional hostnames. You can also subscribe to [https://ip-addresses.origin.konghq.com/rss](https://ip-addresses.origin.konghq.com/rss) for updates. 

## Mesh Manager hostnames

If you plan to use [Mesh Manager](/konnect/mesh-manager/) to manage your Kong service mesh, you must add the `{geo}.mesh.sync.konghq.com:443` hostname to your firewall allowlist. The geo can be `au`, `eu`, `us`, or `global`.
