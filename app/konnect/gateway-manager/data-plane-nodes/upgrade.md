---
title: Upgrade a Data Plane Node to a New Version
content_type: how-to
---

You can upgrade data plane nodes to a new {{site.base_gateway}} version by bringing
up new data plane nodes, and then shutting down the old ones. This is the best
method for high availability, as the new node starts processing data before the
old node is removed. It is the cleanest and safest way to upgrade with no
proxy downtime.

We recommend running one major version (2.x or 3.x) of a data plane node per control plane, unless you are in the middle of version upgrades to the data plane. Mixing versions may cause [compatibility issues](/konnect/gateway-manager/version-compatibility).

## Prerequisites

Read through the [{{site.base_gateway}} upgrade considerations](/gateway/latest/upgrade/) for the version that you're upgrading to.

## Upgrade a data plane node
To upgrade a data plane node to a new version, follow these steps:

{% navtabs %}
{% navtab Dedicated Cloud Gateways %}
{% navtabs %}
{% navtab Konnect UI %}
1. Open [**Gateway Manager**](https://cloud.konghq.com/us/gateway-manager/), choose the Dedicated Cloud Gateways powered control plane,
1. From the **Actions** drop-down menu, select **Update Cluster Config**
1. Select the desired {{site.base_gateway}} version, and **Update Cluster**.

{{site.konnect_short_name}} will upgrade the version of all the data plane nodes to the version you selected automatically. 
{% endnavtab %}
{% navtab API %}

Using the API, you can upgrade your data plane node versions by issuing a POST request to the `/cloud-gateways/configurations` endpoint: 


1. Open [**Gateway Manager**](https://cloud.konghq.com/us/gateway-manager/), choose the Dedicated Cloud Gateways powered control plane, and copy the `control_plane_id`.
1. From the {{site.konnect_short_name}} sidebar, click on **Data Plane Nodes**, select the relevant data plane group, and record the `cloud_gateway_network_id`.
1. Construct and send a POST request to `/cloud-gateways/configurations`, using both the `control_plane_id`, `cloud_gateway_network_id`, and the desired [`version`](/konnect/compatibility/):

    ```bash
    curl --request PUT \
    --url https://us.api.konghq.com/v2/cloud-gateways/configurations \
    --header 'Authorization: Bearer BEARER_TOKEN' \
    --data '{
    "control_plane_id": "CONTROL_PLANE_ID",
    "version": "DESIRED_VERSION",
        "control_plane_geo": "GEO_LOCATION",
    "dataplane_groups": [
        {
        "provider": "aws",
        "region": "ap-northeast-1",
        "cloud_gateway_network_id": "CLOUD_GATEWAY_NETWORK_ID",
        "autoscale": {
                "kind": "autopilot",
                            "base_rps": 100
            }
        }
    ]
    }'
    ```

{:.note}
> Replace `BEARER_TOKEN`, `CONTROL_PLANE_ID`, `DESIRED_VERSION`, `GEO_LOCATION`, and `CLOUD_GATEWAY_NETWORK_ID` with your specific details.


{{site.konnect_short_name}} will upgrade the version of all the data plane nodes to the version you selected automatically, the response body will contain information about the data plane group, including the version. 
{% endnavtab %}
{% endnavtabs %}



{% endnavtab %}
{% navtab Hybrid-mode %}


1. Open {% konnect_icon runtimes %} [**Gateway Manager**](https://cloud.konghq.com/us/gateway-manager/), choose a control plane,
and provision a new data plane node through the Gateway Manager.

    Make sure that your new data plane node appears in the list of nodes, 
    displays a _Connected_ status, and that it was last seen _Just Now_.

1. Once the new data plane node is connected and functioning, disconnect
and shut down the nodes you are replacing.

    {:.note}
    > You can't shut down data plane nodes from within Gateway Manager. Old
    nodes will also remain listed as `Connected` in Gateway Manager for a
    few hours after they have been removed or shut down.

1. Test passing data through your new data plane node by accessing your proxy
URL.

    For example, with the hostname `localhost` and the route path `/mock`:

    ```
    http://localhost:8000/mock
    ```
{% endnavtab %}
{% endnavtabs %}