---
title: Upgrade a Data Plane Node to a New Version
content_type: how-to
---



Self-managed data plane nodes can be upgraded to a new {{site.base_gateway}} by initializing new nodes before decommissioning old ones. This method ensures high availability, allowing the new node to commence data processing prior to the removal of the old node. Managed nodes are upgraded automatically after selecting the new version of {{site.base_gateway}}. 


We recommend running one major version (2.x or 3.x) of a data plane node per control plane, unless you are in the middle of version upgrades to the data plane. Mixing versions may cause [compatibility issues](/konnect/gateway-manager/version-compatibility).

{:.note}
> **Note**: If you don't want to manually upgrade data plane nodes, you can use a Dedicated Cloud Gateway. With cloud gateways, Kong fully-manages the data plane and handles upgrades for you.

## Prerequisites

Read through the [{{site.base_gateway}} upgrade considerations](/gateway/latest/upgrade/) for the version that you're upgrading to.

## Upgrade a data plane node
To upgrade a data plane node to a new version, follow these steps:

{% navtabs %}
{% navtab Dedicated Cloud Gateways %}
{% navtabs %}
{% navtab Konnect UI %}
1. In [**Gateway Manager**](https://cloud.konghq.com/us/gateway-manager/), select the Dedicated Cloud Gateways powered control plane you want to upgrade the data plane nodes for.
1. From the **Actions** menu, select **Update Cluster Config**.
1. Select the desired {{site.base_gateway}} version, and click **Update Cluster**.

{{site.konnect_short_name}} will upgrade the version of all the data plane nodes to the version you selected automatically. 

Kong performs a rolling upgrade of the fully-managed data plane nodes. This is a zero downtime upgrade because Kong synchronizes the data plane with load balancer registration and de-registration and gracefully terminates the old data plane nodes to reduce the impact on the ongoing traffic.
{% endnavtab %}
{% navtab API %}

Using the `control-plane-id` for the data plane group you want to upgrade, you can upgrade via the API by following these steps:


1. Send a GET request to the `/cloud-gateway/networks/` endpoint, the response will contain a list of all the active Cloud Gateway networks.

    ```bash
    curl --request GET \
    --url https://us.api.konghq.com/v2/cloud-gateways/networks \
    --header 'Authorization: Bearer kpat_iIGUb6bPml2G6WUSPnZMLdty6pwgUf8GIJbSlBlasg6w4y1cS'
  ```
1. From the response body save the `cloud_gaetway_network_id`, `control_plane_id`. 
1. Construct and send a POST request to `/cloud-gateways/configurations`, using both the `control_plane_id`, `cloud_gateway_network_id`, and the desired [`version`](/konnect/compatibility/):

    ```bash
    curl --request PUT \
    --url https://{region}.api.konghq.com/v2/cloud-gateways/configurations \
    --header 'Authorization: Bearer BEARER_TOKEN' \
    --data '{
    "control_plane_id": "CONTROL_PLANE_ID",
    "version": "DESIRED_VERSION",
        "control_plane_geo": "GEO_LOCATION",
    "dataplane_groups": [
        {
        "provider": "aws",
        "region": "REGION",
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
> Replace `BEARER_TOKEN`, `CONTROL_PLANE_ID`, `DESIRED_VERSION`, `GEO_LOCATION`, `REGION`, and `CLOUD_GATEWAY_NETWORK_ID` with your specific details.


{{site.konnect_short_name}} will upgrade the version of all the data plane nodes to the version you selected automatically, the response body will contain information about the data plane group, including the version. 

Kong performs a rolling upgrade of the fully-managed data plane nodes. This is a zero downtime upgrade because Kong synchronizes the data plane with load balancer registration and de-registration and gracefully terminates the old data plane nodes to reduce the impact on the ongoing traffic.
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