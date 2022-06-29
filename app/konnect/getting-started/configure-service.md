---
title: Configuring a Service
no_version: true
---

Using the [Service Hub](/konnect/servicehub), you can create, manage, and
implement {{site.konnect_short_name}} services. Each service consists of at least one
service version, and each service version can have one implementation.

![{{site.konnect_short_name}} service diagram](/assets/images/docs/konnect/konnect-services-diagram.png)

For the purpose of this guide, you’ll create a service, version it, and
expose the version by creating an implementation pointing to the Mockbin API.
Mockbin is an *echo*-type public website that returns requests back to the
requester as responses.

## Prerequisites

If you're following the {{site.konnect_short_name}} quickstart guide,
make sure you have [configured a runtime](/konnect/getting-started/configure-runtime).

## Create a service

1. From the left navigation menu, open {% konnect_icon servicehub %} **Service Hub**.

1. Click **New service**.

1. Enter a **Display name**. For this example, enter `example_service`.

    A display name can be any string containing letters, numbers, or the following
    characters: `.`, `-`, `_`, `~`, or `:`. Do not use spaces in version names.

    For example, you can use `service_name`, `ServiceName`, or `Service-name`.
    However, `Service Name` is invalid.

1. (Optional) Enter a **Description**.

    This description is used in {{site.konnect_short_name}} and on the Dev Portal.

1. Click **Create**.

    You can now see your new service's overview page.

    Now that you have a service set up, you can start filling out details about your
    API.

## Create a service version

Let's set up the first version of your API service.

1. On your service's overview page, click **Service actions** >
**Add new version**.

1. Enter a **Version Name**. For this example, enter `v1`.

    A version name can be any string containing letters, numbers, or characters;
    for example, `1.0.0`, `v1`, or `version#1`. A service can have multiple
    versions.

1. Select a runtime group.

    Choose a [group](/konnect/runtime-manager/runtime-groups) to
    deploy this service version to. This lets you deploy to a specific group of
    runtime instances in a specific environment.

    {:.note}
    > **Note:** Application registration is only available for
    services in the default runtime group, so if you plan on using
    [application registration](/konnect/dev-portal/applications/application-overview),
    choose `default` in this step.

    Different versions of the same service can run in different runtime groups.
    The version name is unique within a group:

    * If you create multiple versions in the **same group**, they must have unique names.
    * If you create multiple versions in **different groups**, the versions can have the same name.

1. Click **Create** to save.

## Summary and next steps

In this section, you added a service named `example_service` with the version
`v1`.

Next, go on to [implement the service version](/konnect/getting-started/implement-service).
