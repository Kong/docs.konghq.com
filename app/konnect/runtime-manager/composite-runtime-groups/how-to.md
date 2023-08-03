---
title: Working with composite runtime groups
content_type: how-to
badge: enterprise
---

A composite runtime group (CRG) is a read-only group that combines configuration from its members, which are standard runtime groups (SRG). All of the standard runtime groups within a composite runtime group share the same cluster of runtime instances.

In this guide, you will set up a composite runtime groups with two members, then test that the configuration from both member groups is applied to the composite.

## Prerequisites

* You must have the **runtime group admin** role to fully manage composite runtime groups.
* If you are using the {{site.konnect_short_name}} API, you have a personal or system access token.

## Using composite runtime groups

### Set up standard runtime groups

First, let's create a standard runtime group. 
This group will be a member of a composite runtime group later on.

If you already have some standard runtime groups in your org that you want to add to a composite, skip to [creating a composite runtime group](#create-composite-runtime-group).

{% navtabs %}
{% navtab Konnect UI %}

1. From the navigation menu, open {% konnect_icon runtimes %} **Runtime Manager**.
1. Click the **New Runtime Group** button and select **{{site.base_gateway}}**.
   
   Kong Ingress Controller runtime groups can't be part of composite groups. One composite runtime group cannot be a member of another composite runtime group. 

1. Set up your group and save. For the purpose of this example, the group name will be SRG1.
1. Create another {{site.base_gateway}} group, this time calling it SRG2.

{% endnavtab %}
{% navtab API %}

Create some standard runtime groups.

1. Create group `SRG1`:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/runtime-groups \
        -H "Authorization: Bearer <your_KPAT>" \
        --data "name=SRG1" \
        --data "cluster_type=CLUSTER_TYPE_HYBRID"
    ```

1. Create group `SRG2`:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/runtime-groups \
        -H "Authorization: Bearer <your_KPAT>" \
        --data "name=SRG2" \
        --data "cluster_type=CLUSTER_TYPE_HYBRID"
    ```

{% endnavtab %}
{% endnavtabs %}

### Set up composite runtime group

Next, create a composite runtime group with the groups `SRG1` and `SRG2` as its members.

{% navtabs %}
{% navtab Konnect UI %}

1. From the navigation menu, open {% konnect_icon runtimes %} **Runtime Manager**.
1. Click the **New Runtime Group** button and select **Composite Runtime**.
1. Set up the runtime. The name of the group must be unique.

    In the **Runtime Groups** field, add the `SRG1` and `SRG2` groups.

    {:.note}
    > **Note**: When adding a standard group to a composite, make sure it has no connected 
    runtime instances.

{% endnavtab %}
{% navtab API %}

1. Create a composite runtime group:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/runtime-groups \
        -H "Authorization: Bearer <your_KPAT>" \
        --data "name=CRG" \
        --data "cluster_type=CLUSTER_TYPE_COMPOSITE"
    ```

    Copy the runtime group ID from the response:

    ```json
    HTTP/2 201

    {
        "id": "2b802e10-fd6b-4b12-8dbd-ffff4ac8b258",
        "name": "CRG",
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

1. Find the IDs of `SRG1` and `SRG2`:

    ```sh
    curl -i -X GET https://<region>.api.konghq.com/v2/runtime-groups/
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
                "name": "SRG1",
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
                "name": "SRG2",
                "updated_at": "2023-06-29T04:55:26.590Z"
            }
            ...
        ],
    }
    ```

1. Add the groups SRG1 and SRG2 to your composite runtime group:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/runtime-groups/<composite-group-ID>/composite-memberships/add \
        -H "Authorization: Bearer <your_KPAT>" \
        --json '{"members": [{"id": "<SRG1-ID>", "id": "<SRG2-ID>"}]}'
    ```

    Response:

    ```
    HTTP/2 204
    ```

    {:.note}
    > **Note**: When adding a standard group to a composite, make sure it has no connected 
    runtime instances.

{% endnavtab %}
{% endnavtabs %}

### Set up a runtime instance

Set up a runtime instance in the composite runtime group. 
Navigate to {% konnect_icon runtimes %} [**Runtime Manager**](https://cloud.konghq.com/runtime-manager/), select group `CRG`, then click on **New Runtime Instance**.

Choose your installation method, then follow the instructions in {{site.konnect_short_name}} to set up the runtime instance.

Once the instance is connected, go back to the runtime manager.

### Configure standard runtime groups

Create a service and route in `SRG1`. This will let you test the connection between groups.

{% navtabs %}
{% navtab Konnect UI %}

1. Open the SRG1 runtime group from Runtime Manager.
1. In the side menu, go to **Gateway Services**.
1. Click the **New Gateway Service** button and set up the service. 
For this example, you can use the following values:
   * Name: `example_service`
   * Host: `mockbin.org`

1. Next, create a route. From the side menu, open **Routes**.
1. Click the **New Route** button and set up the route. For this example, you can enter `/mock` in the paths field.

{% endnavtab %}
{% navtab API %}

1. Find the IDs of the runtime groups `SRG1` and `SRG2`:

    ```sh
    curl -i -X GET https://<region>.api.konghq.com/v2/runtime-groups/
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
                "name": "SRG1",
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
                "name": "SRG2",
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
                "name": "CRG",
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

1. In `SRG1`, create a service and a route:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/runtime-groups/<runtime-group-id>/core-entities/services \
        -H "Authorization: Bearer <your_KPAT>"  \
        --data "name=example_service" \
        --data "host=mockbin.org"
    ```

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/runtime-groups/<runtime-group-id>/core-entities/services/example_service/routes \
        -H "Authorization: Bearer <your_KPAT>"  \
        --data "paths[]=/mock"
    ```

{% endnavtab %}
{% endnavtabs %}

## Validate

Let's test that the configurations from `SRG1` and `SRG2` are both being applied to the proxy running on `CRG`.

You should now have three runtime groups with the following configurations:
* `SRG1`: Has a service (`example_service`) and a route (`/mock`)
* `SRG2`: Nothing configured
* `CRG`: Has one runtime instance

First, test the configuration of `SRG1` by accessing it through the proxy URL `localhost:8000`, which is running on the instance configured in the `CRG`.

{% navtabs %}
{% navtab Konnect UI %}

1. Try to access the route you set up in `SRG1`. In a web browser, navigate to `http://localhost:8000/mock/request/hello`. 

    You should see a mock request page.

1. Return to Runtime Manager in {{site.konnect_short_name}} and open `SRG2`. 

1. Set up the basic authentication plugin. 

    1. In the side menu, go to **Plugins**.
    1. Find and enable the **Basic Authentication** plugin. You can accept the default values.

1. Wait a few seconds, then try to access the route again from your browser. 
This time, you should receive a prompt to enter a username and password.

{% endnavtab %}
{% navtab API %}

1. Try to access the route you set up in `SRG1`:

    ```
    curl localhost:8000/mock/request/hello
    ```

    You should see a response from Mockbin.

1. Find the ID of `SRG2`. In `SRG2`, set up the basic authentication plugin:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/runtime-groups/<runtime-group-id>/core-entities/plugins \
            -H "Authorization: Bearer <your_KPAT>"  \
            --data "name=basic-auth"
    ```

1. Wait a few seconds, then try to access the route again. This time, you shouldn't be able to access it:

    ```sh
    curl localhost:8000/mock/request/hello
    ```

    Response:
    ```json
    {"message":"Unauthorized"}
    ```

{% endnavtab %}
{% endnavtabs %}

This means that the route is active, and the basic authentication plugin is blocking access to the route.

Since you were able to access the route, apply an auth plugin, then authorization to the route, it means that the configuration from both member runtime groups was applied. You now have a working composite runtime group!