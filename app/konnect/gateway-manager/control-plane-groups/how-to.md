---
title: Working with control plane groups
content_type: how-to
badge: enterprise
---

A control plane group (CPG) is a read-only group that combines configuration from its members, which are standard control planes (CP). All of the standard control planes within a control plane group share the same cluster of data plane nodes.

In this guide, you will set up a control plane groups with two members, then test that the configuration from both member control planes is applied to the group.

## Prerequisites

* You must have the **control plane admin** role to fully manage control plane groups.
* If you are using the {{site.konnect_short_name}} API, you have a personal or system access token.

## Using control plane groups

### Set up standard control planes

First, let's create a standard control plane. 
This control plane will be a member of a control plane group later on.

If you already have some standard control planes in your org that you want to add to a group, skip to [creating a control plane group](#set-up-control-plane-group).

{% navtabs %}
{% navtab Konnect UI %}

1. From the navigation menu, open {% konnect_icon runtimes %} **Gateway Manager**.
1. Click the **New Control Plane** button and select **{{site.base_gateway}}**.
   
   Kong Ingress Controller control planes can't be part of control plane groups. One control plane group cannot be a member of another control plane group. 

1. Set up your control plane and save. For the purpose of this example, its name will be CP1.
1. Create another {{site.base_gateway}} control plane, this time calling it CP2.

{% endnavtab %}
{% navtab API %}

Create some standard control planes.

1. Create control plane `CP1`:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/control-planes \
        -H "Authorization: Bearer <your_KPAT>" \
        --data "name=CP1" \
        --data "cluster_type=CLUSTER_TYPE_HYBRID"
    ```

1. Create control plane `CP2`:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/control-planes \
        -H "Authorization: Bearer <your_KPAT>" \
        --data "name=CP2" \
        --data "cluster_type=CLUSTER_TYPE_HYBRID"
    ```

{% endnavtab %}
{% endnavtabs %}

### Set up control plane group

Next, create a control plane group with the control planes `CP1` and `CP2` as its members.

{% navtabs %}
{% navtab Konnect UI %}

1. From the navigation menu, open {% konnect_icon runtimes %} **Gateway Manager**.
1. Click the **New Control Plane** button and select **Control Plane Group**.
1. Set up the group. The name of the group must be unique.

    In the **Control Planes** field, add the `CP1` and `CP2` control planes.

    {:.note}
    > **Note**: When adding a standard control plane to a control plane group,
    make sure it has no connected data plane nodes.

{% endnavtab %}
{% navtab API %}

1. Create a control plane group:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/control-planes \
        -H "Authorization: Bearer <your_KPAT>" \
        --data "name=CPG" \
        --data "cluster_type=CLUSTER_TYPE_COMPOSITE"
    ```

    Copy the control plane ID from the response:

    ```json
    HTTP/2 201

    {
        "id": "2b802e10-fd6b-4b12-8dbd-ffff4ac8b258",
        "name": "CPG",
        "description": "",
        "labels": {},
        "config": {
            "control_plane_endpoint": "https://c89sa6fgas.us.cp0.konghq.com",
            "telemetry_endpoint": "https://c89sa6fgas.us.tp0.konghq.com",
            "cluster_type": "CLUSTER_TYPE_COMPOSITE"
        },
        "created_at": "2023-06-29T04:55:26.590Z",
        "updated_at": "2023-06-29T04:55:26.590Z"
        }
    ```

1. Find the IDs of `CP1` and `CP2`:

    ```sh
    curl -i -X GET https://{region}.api.konghq.com/v2/control-planes/
    ```

    ```json
    HTTP/1.1 200 OK

    {
        "data": [
            {
                "config": {
                    "cluster_type": "CLUSTER_TYPE_HYBRID",
                    "control_plane_endpoint": "https://27faf0d0dsf.us.cp0.konghq.com",
                    "telemetry_endpoint": "https://27faf0d0dsf.us.tp0.konghq.com"
                },
                "created_at": "2023-06-29T04:55:26.590Z",
                "description": "",
                "id": "fb2fc564-96bc-4667-80af-c00e9aed2ab2",
                "labels": {},
                "name": "CP1",
                "updated_at": "2023-06-29T04:55:26.590Z"
            },
            {
                "config": {
                    "cluster_type": "CLUSTER_TYPE_HYBRID",
                    "control_plane_endpoint": "https://27faf0d0dsf.us.cp0.konghq.com",
                    "telemetry_endpoint": "https://27faf0d0dsf.us.tp0.konghq.com"
                },
                "created_at": "2023-06-29T04:55:26.590Z",
                "description": "",
                "id": "e78012ce-553b-4305-adb2-3231bc0570b4",
                "labels": {},
                "name": "CP2",
                "updated_at": "2023-06-29T04:55:26.590Z"
            }
            ...
        ],
    }
    ```

1. Add the control planes CP1 and CP2 to your control plane group:

    ```sh
    curl -i -X POST https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/group-memberships/add \
        -H "Authorization: Bearer <your_KPAT>" \
        --json '{"members": [{"id": "<CP1-ID>", "id": "<CP2-ID>"}]}'
    ```

    Response:

    ```
    HTTP/2 204
    ```

    {:.note}
    > **Note**: When adding a standard control plane to a group, make sure it has no connected 
    data plane nodes.

{% endnavtab %}
{% endnavtabs %}

### Set up a data plane node

Set up a data plane node in the control plane group. 
Navigate to {% konnect_icon runtimes %} [**Gateway Manager**](https://cloud.konghq.com/gateway-manager/), select
group `CPG`, select **Data Plane Nodes** from the navigation menu, then click on the **New Data Plane Node** button.

Choose your installation method, then follow the instructions in {{site.konnect_short_name}} to set up the data plane node.

Once the data plane node is connected, go back to the Gateway Manager.

### Configure standard control planes

Create a service and route in `CP1`. This will let you test the connection between members of a group.

{% navtabs %}
{% navtab Konnect UI %}

1. Open the CP1 control plane from Gateway Manager.
1. In the side menu, go to **Gateway Services**.
1. Click the **New Gateway Service** button and set up the service. 
For this example, you can use the following values:
   * Name: `example_service`
   * Host: `httpbin.org`

1. Next, create a route. From the side menu, open **Routes**.
1. Click the **New Route** button and set up the route. For this example, you can enter `/mock` in the paths field.

{% endnavtab %}
{% navtab API %}

1. Find the IDs of the control planes `CP1` and `CP2`:

    ```sh
    curl -i -X GET https://{region}.api.konghq.com/v2/control-planes
    ```

    Response:

    ```json
    HTTP/1.1 200 OK

    {
        "data": [
            {
                "config": {
                    "cluster_type": "CLUSTER_TYPE_HYBRID",
                    "control_plane_endpoint": "https://27faf0d0dsf.us.cp0.konghq.com",
                    "telemetry_endpoint": "https://27faf0d0dsf.us.tp0.konghq.com"
                },
                "created_at": "2023-06-29T04:55:26.590Z",
                "description": "",
                "id": "fb2fc564-96bc-4667-80af-c00e9aed2ab2",
                "labels": {},
                "name": "CP1",
                "updated_at": "2023-06-29T04:55:26.590Z"
            },
            {
                "config": {
                    "cluster_type": "CLUSTER_TYPE_HYBRID",
                    "control_plane_endpoint": "https://27faf0d0dsf.us.cp0.konghq.com",
                    "telemetry_endpoint": "https://27faf0d0dsf.us.tp0.konghq.com"
                },
                "created_at": "2023-06-29T04:55:26.590Z",
                "description": "",
                "id": "e78012ce-553b-4305-adb2-3231bc0570b4",
                "labels": {},
                "name": "CP2",
                "updated_at": "2023-06-29T04:55:26.590Z"
            },
            {
                "config": {
                    "cluster_type": "CLUSTER_TYPE_COMPOSITE",
                    "control_plane_endpoint": "https://27faf0d0dsf.us.cp0.konghq.com",
                    "telemetry_endpoint": "https://27faf0d0dsf.us.tp0.konghq.com"
                },
                "created_at": "2023-06-29T04:55:26.590Z",
                "description": "",
                "id": "2b802e10-fd6b-4b12-8dbd-ffff4ac8b258",
                "labels": {},
                "name": "CPG",
                "updated_at": "2023-06-29T04:55:26.590Z"
            }
        ],
        "meta": {
            "page": {
                "number": 1,
                "size": 100,
                "total": 3
            }
        }
    }
    ```

1. In `CP1`, create a service and a route:

    ```sh
    curl -i -X POST https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/services \
        -H "Authorization: Bearer <your_KPAT>"  \
        --data "name=example_service" \
        --data "host=httpbin.org"
    ```

    ```sh
    curl -i -X POST https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/services/example_service/routes \
        -H "Authorization: Bearer <your_KPAT>"  \
        --data "paths[]=/mock"
    ```

{% endnavtab %}
{% endnavtabs %}

## Validate

Let's test that the configurations from `CP1` and `CP2` are both being applied to the proxy running on `CPG`.

You should now have three control planes with the following configurations:
* `CP1`: Has a service (`example_service`) and a route (`/mock`)
* `CP2`: Nothing configured
* `CPG`: Has one data plane node

First, test the configuration of `CP1` by accessing it through the proxy URL `localhost:8000`, which is 
running on the data plane node configured in the `CPG`.

{% navtabs %}
{% navtab Konnect UI %}

1. Try to access the route you set up in `CP1`. In a web browser, navigate to `http://localhost:8000/mock/anything/hello`. 

    You should see a mock request page.

1. Return to Gateway Manager in {{site.konnect_short_name}} and open `CP2`. 

1. Set up the basic authentication plugin. 

    1. In the side menu, go to **Plugins**.
    1. Find and enable the **Basic Authentication** plugin. You can accept the default values.

1. Wait a few seconds, then try to access the route again from your browser. 
This time, you should receive a prompt to enter a username and password.

{% endnavtab %}
{% navtab API %}

1. Try to access the route you set up in `CP1`:

    ```
    curl localhost:8000/mock/anything/hello
    ```

    You should see a response from httpbin.

1. Find the ID of `CP2`. In `CP2`, set up the basic authentication plugin:

    ```sh
    curl -i -X POST https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/plugins \
            -H "Authorization: Bearer <your_KPAT>"  \
            --data "name=basic-auth"
    ```

1. Wait a few seconds, then try to access the route again. This time, you shouldn't be able to access it:

    ```sh
    curl localhost:8000/mock/anything/hello
    ```

    Response:
    ```json
    {"message":"Unauthorized"}
    ```

{% endnavtab %}
{% endnavtabs %}

This means that the route is active, and the basic authentication plugin is blocking access to the route.

Since you were able to access the route, apply an auth plugin, and then add authorization to the route, it means that the configuration from both member control planes was applied. You now have a working control plane group.