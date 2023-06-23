---
title: Productize a Service
---

Using [API Products](/konnect/api-products), you can create and manage API products to productize your services. Each API product consists of at least one API product version, and each API product version is connected to a gateway service. Creating API products is the first step in making your APIs and their documentation available to developers.

![{{site.konnect_short_name}} service diagram](/assets/images/docs/konnect/konnect-services-diagram.png)

This guide will walk you through creating an API product and productizing it by deploying it to the Dev Portal.

## Prerequisites

If you're following the {{site.konnect_short_name}} quickstart guide,
make sure you have [configured a runtime](/konnect/getting-started/configure-runtime/).

## Create an API product <!--these steps will need to be verified once customer 0 happens-->

Let's set up your first API product and API product version, by clicking {% konnect_icon api-product %} [**API Products**](https://cloud.konghq.com/apiproducts) from the {{site.konnect_short_name}} side navigation bar.

1. Select **API Product** from the API products dashboard to add a new API product.

1. Create a new name for your API product, and enter an optional **Description** and any **labels** that you want to associate with the product, then press **create**. 

You will be greeted by the dashboard for the API product that you just created. You can use this dashboard to manage an API product. You can read more about this dashboard on our API products [overview page](/konnect/api-products/)

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

    Choose a [runtime group](/konnect/runtime-manager/runtime-groups/) and [Gateway Service](/konnect/runtime-manager/configuration/#gateway-services) to
    deploy this API product version to. This lets you deploy to a specific group of
    runtime instances in a specific environment.

    {:.note}
    > **Note:** Application registration is only available for
    services in the default runtime group, so if you plan on using
    [application registration](/konnect/dev-portal/applications/application-overview/),
    choose `default` in this step.

    Different versions of the same API product can run in different runtime groups.
    The version name is unique within a group:

    * If you create multiple versions in the _same group_, they must have unique names.
    * If you create multiple versions in _different groups_, the versions can have the same name.
1. Click **Save**.

## Publish an API product

API products can be productized by publishing them to the Dev Portal. To productize your new API product navigate to the {% konnect_icon api-product %} [**API Product builder**](https://cloud.konghq.com/apiproducts) and follow these steps: 

1. Select the API product that you created in the previous step.
2. Navigate to the **Actions** menu, then select **publish**. 

Your API product is now consumable by developers from the **Dev Portal**.


## Next steps

In this section, you added an API product, associated a product version to it, and productized it by publishing to the Dev Portal. 

Next, [publish the API product to the Dev Portal](/konnect/getting-started/publish-service/)
and test out the Dev Portal from the perspective of a developer.
