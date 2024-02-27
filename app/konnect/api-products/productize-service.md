---
title: Productize a Service
---

Using [API Products](/konnect/api-products), you can create and manage API products to productize your services. Each API product consists of at least one API product version, and each API product version is connected to a Gateway service. Creating API products is the first step in making your APIs and their documentation available to developers. API products are geo-specific and are not shared between [geographic regions](/konnect/geo/).

![{{site.konnect_short_name}} service diagram](/assets/images/products/konnect/gateway-manager/konnect-services-diagram.png)

This guide will walk you through creating an API product and productizing it by deploying it to the Dev Portal.

## Prerequisites

* [A service created](/konnect/gateway-manager/deploy-service).

## Create an API product <!--these steps will need to be verified once customer 0 happens-->

You can set up an API product and API product version by clicking {% konnect_icon api-product %} [**API Products**](https://cloud.konghq.com/api-products) from the {{site.konnect_short_name}} side navigation bar.

1. Select **API Product** from the API products dashboard to add a new API product.

1. Create a new name for your API product, and enter an optional **Description** and any **labels** that you want to associate with the product, then press **create**. 

You will be greeted by the dashboard for the API product that you just created. You can use this dashboard to manage an API product. You can read more about this dashboard on the API products [overview page](/konnect/api-products/)

### Create an API product version

After creating a new API product, you can attach an API product version to it.

1. From the API product builder, select **Product Versions**, then select **New Version**.

1. Enter a version name. For example `v1`.
     A version name can be any string containing letters, numbers, or characters;
     for example, `1.0.0`, `v1`, or `version#1`. A service can have multiple
     versions.
1. Click **Create** to finish creating the product version and be taken to the **Product Versions dashboard**.

After creating the new version, you will see **Link with a Gateway Service** as an option in the Product Version Dashboard. You can link a Gateway service to your product version to enable features like App registration. 

1. Select **Link with a Gateway Service**. 

    Choose the [control plane](/konnect/gateway-manager/control-plane-groups/) and [Gateway Service](/konnect/gateway-manager/configuration/#gateway-services) to
    deploy this API product version to. This lets you deploy your service across data plane nodes associated with the control plane.
1. Click **Save**.

## Publish an API product

API products can be published to the Dev Portal. To publish your new API product navigate to the {% konnect_icon api-product %} [**API Products**](https://cloud.konghq.com/api-products) and follow these steps: 

1. Select the API product that you created in the previous step.
2. Navigate to the **Actions** menu, then select **publish**. 

Your API product is now consumable by developers from the **Dev Portal**.


## Summary

In this section, you added an API product, linked a Gateway service via an API product version to it, and published it to the Dev Portal. 

## More information

* [Add API product documentation](/konnect/dev-portal/publish-service/): Learn how to add API product documentation and test out the Dev Portal from the perspective of a developer.
