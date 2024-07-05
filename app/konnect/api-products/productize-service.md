---
title: Publish an API to Dev Portal
---

Using [API Products](/konnect/api-products), you can create and manage API products to productize your services. Each API product consists of at least one API product version, and each API product version is connected to a Gateway service. Creating API products is the first step in making your APIs and their documentation available to developers. API products are geo-specific and are not shared between [geographic regions](/konnect/geo/).

![{{site.konnect_short_name}} service diagram](/assets/images/products/konnect/gateway-manager/konnect-services-diagram.png)

This guide will walk you through creating an API product and productizing it by deploying it to the Dev Portal.

## Prerequisites

* [A service created](/konnect/gateway-manager/deploy-service).

## Create an API product 
{% navtabs %}
{% navtab Konnect UI %}

You can set up an API product and API product version by clicking {% konnect_icon api-product %} [**API Products**](https://cloud.konghq.com/api-products) from the {{site.konnect_short_name}} side navigation bar.

1. Select **API Product** from the API products dashboard to add a new API product.

1. Create a new name for your API product, and enter an optional **Description** and any **labels** that you want to associate with the product, then click **Create**. 

You will be greeted by the dashboard for the API product that you just created. You can use this dashboard to manage an API product. You can read more about this dashboard on the API products [overview page](/konnect/api-products/)
{% endnavtab %}
{% navtab API%}

Create a new API product by issuing a `POST` request to the [`/api-products`](/konnect/api/api-products/latest/#/API%20Products/create-api-product) endpoint. 

```sh
curl -X 'POST' \
    'https://{region}.api.konghq.com/v2/api-products' \
    -H 'accept: application/json' \
    -H 'Authorization: Bearer <personal-access-token>' \
    -H 'Content-Type: application/json' \
    -d '{
    "name": "API Product"
    }'
```

The response body will include an `id` field, denoting the unique identifier for your newly created API product. Save this identifier because you will need it in subsequent steps. 
{% endnavtab %}
{% endnavtabs %}

### Create an API product version
{% navtabs %}
{% navtab Konnect UI %}
After creating a new API product, you can attach an API product version to it.

1. In {% konnect_icon api-product %} [**API Products**](https://cloud.konghq.com/api-products), click the API product you want to create the version for and then click **Product Versions**, then click **New Version**.

1. Enter a version name. For example `v1`.
     A version name can be any string containing letters, numbers, or characters;
     for example, `1.0.0`, `v1`, or `version#1`. An API product can have multiple
     versions.
1. Click **Create** to finish creating the product version and be taken to the **Product Versions dashboard**.

After creating the new version, you will see **Link with a Gateway Service** as an option in the Product Version Dashboard. You can link a Gateway service to your product version to enable features like App registration. 

1. Select **Link with a Gateway Service**. 

    Choose the [control plane](/konnect/gateway-manager/control-plane-groups/) and [Gateway Service](/konnect/gateway-manager/configuration/#gateway-services) to
    deploy this API product version to. This lets you deploy your service across data plane nodes associated with the control plane.
1. Click **Save**.
{% endnavtab %}
{% navtab API%}

1. To create a new API product version, execute a `POST` request to the  [`/product-versions/`](/konnect/api/api-products/latest/#/API%20Product%20Versions/create-api-product-version) endpoint, replace `{id}` with your API product's actual ID:

    ```sh
    curl -X 'POST' \
        'https://{region).api.konghq.com/v2/api-products/{id}/product-versions' \
        -H 'accept: application/json' \
        -H 'Authorization: Bearer <personal-access-token>' \
        -H 'Content-Type: application/json' \
        -d '{
        "name": "v1"
        }'
    ```


1. After creating the new version, you can link a Gateway service to your product version to enable features like application registration by issuing a `POST` request to the [`/api-product-versions/`](/konnect/api/api-products/latest/#/API%20Product%20Versions/create-api-product-version) endpoint. Ensure you replace `{id}` with your API product's ID, `{control_plane_id}` with your control plane's ID, and include the relevant Gateway service ID in the request body.

    ```sh
    curl -X 'POST' \
    'https://{region).api.konghq.com/v2/api-products/{id}/product-versions' \
        -H 'accept: application/json' \
        -H 'Authorization: Bearer <personal-access-token>' \
        -H 'Content-Type: application/json' \
        -d '{
        "name": "v1",
        "gateway_service": {
            "control_plane_id": "e4d9ebb1-26b4-426a-b00e-cb67044f3baf",
            "id": "09b4786a-3e48-4631-8f6b-62d1d8e1a7f3"
        }
        }'
    ```
{% endnavtab %}
{% endnavtabs %}
## Publish an API product

{% navtabs %}
{% navtab Konnect UI %}

1. In {% konnect_icon api-product %} [**API Products**](https://cloud.konghq.com/api-products), select the API product that you created in the previous step.
1. Click **Add** on the API Product Overview page and select **Publish to Dev Portals**. You will see a modal prompting you to select which Dev Portals you want to publish your API product to. 
1. Click **Publish** for the Dev Portals you want to publish it to. Then, click **Finish**. 
1. In {% konnect_icon api-product %} [**API Products**](https://cloud.konghq.com/api-products), select the API product you added to the Dev Portal. 
1. Click **Product Versions** in the sidebar.
1. Click the product version you created previously and click the **Dev Portals** tab. Click **Publish to Dev Portals** and select the Dev Portals you want to add the product version to.
1. Optional: If you want to require authentication on your API product version, enable **Require Authentication** and select which authentication strategy applications registering to your API should use. For more information about how to configure authentication, see [Enable or Disable Application Registration for an API Product Version](/konnect/dev-portal/applications/enable-app-reg/).

The API product and product versions you published should now be displayed in the Dev Portals you selected.
{% endnavtab %}
{% navtab API %}

1. Before you publish the API product version, you must first assign the API product to any Dev Portals by issuing a `PATCH` request to the [`/api-products/{id}](/konnect/api/api-products/latest/#/API%20Products/update-api-product) endpoint:

    ```sh
    curl --request PATCH \
        --url https://{region}.api.konghq.com/v2/api-products/{id} \
        --header 'Authorization: <personal-access-token>' \
        --header 'Content-Type: application/json' \
        --data '{
        "portal_ids": [
            "4602b8cc-92fb-4197-b836-3eab20b16147"
        ]
    }'
    ```
    Be sure to replace `{id}` and `portal_ids` with your own values.

1. You can publish an API product version by issuing a `POST` request to the [`/api-product-versions/`](/konnect/api/api-products/latest/#/API%20Product%20Versions/create-api-product-version) endpoint. Ensure you replace `{id}` with the API product ID returned in the previous step. 

    ```sh
    curl -X 'POST' \
        'https://{region}.api.konghq.com/v2/api-products/{id}/product-versions' \
        -H 'accept: application/json' \
        -H 'Authorization: Bearer <personal-access-token>' \
        -H 'Content-Type: application/json' \
        -d '{
        "name": "v1",
        "publish_status": "published"
        }'
    ```
{% endnavtab %}
{% endnavtabs %}

## Summary

In this section, you created an API product and an API product version with a linked Gateway service. You then published both the API product and API product version to one or more Dev Portals. 

## More information

* [Add API product documentation](/konnect/dev-portal/publish-service/): Learn how to add your API spec and API product documentation to the Dev Portal so it's easier for developers to consume your APIs.
