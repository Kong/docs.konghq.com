---
title: Productize a Service
---

Using [API Products](/konnect/api-products), you can create and manage API products to productize your services. Each API product consists of at least one service version, and each API product version is connected to a gateway service. Creating API products is the first step in making your APIs and their documentation available to developers.

![{{site.konnect_short_name}} service diagram](/assets/images/docs/konnect/konnect-services-diagram.png)

For the purpose of this guide, you’ll create an API product and version.

## Prerequisites

If you're following the {{site.konnect_short_name}} quickstart guide,
make sure you have [configured a runtime](/konnect/getting-started/configure-runtime/).

## Create an API product <!--these steps will need to be verified once customer 0 happens-->

Let's set up your first API product and API product version.

1. In the {% konnect_icon  %} [**API Products**](https://cloud.konghq.com/apiproducts), click **API Product**.

1. Enter `Example Product` in the **Product Name** field and click **Create**.

1. Open the `Example Product` you just created, and then click **Add** > **New Version**.

1. Enter a version name. For this example, enter `v1`.

    A version name can be any string containing letters, numbers, or characters;
    for example, `1.0.0`, `v1`, or `version#1`. A service can have multiple
    versions.

1. Select a runtime group.

    Choose a [group](/konnect/runtime-manager/runtime-groups/) to
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

## Deploy and productize an API product version

<!--add steps here-->

## Summary and next steps

In this section, you added a service named `example_service` with the version
`v1`.

Next, [publish the API product to the Dev Portal](/konnect/getting-started/publish-service/)
and test out the Dev Portal from the perspective of a developer.
