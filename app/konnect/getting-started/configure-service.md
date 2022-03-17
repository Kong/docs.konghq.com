---
title: Configuring a Service
no_version: true
---

Using the [Service Hub](/konnect/servicehub), you can create, manage, and
implement Services. Each Service consists of at least one
Service version, and each Service version can have one implementation.

![{{site.konnect_short_name}} Service diagram](/assets/images/docs/konnect/konnect-services-diagram.png)

For the purpose of this guide, you’ll create a Service, version it, and
expose the version by creating an implementation pointing to the Mockbin API.
Mockbin is an *echo*-type public website that returns requests back to the
requester as responses.

## Prerequisites

If you're following the {{site.konnect_short_name}} quickstart guide,
make sure you have [configured a runtime](/konnect/getting-started/configure-runtime).

## Create a Service

1. From the left navigation menu, click **Services** to open Service Hub.

1. Click **Add New Service**.

1. Enter a **Service Name**. For this example, enter `example_service`.

    A Service name can be any string containing letters, numbers, or characters;
    for example, `service_name`, `Service Name`, or `Service-name`.

1. (Optional) Enter a **Description**.

    This description is used in Konnect only. It won't appear on the Dev
    Portal.

1. Click **Create**.

    A new Service is created and the page automatically redirects back to the
    **example_service** overview page.

## Create a Service version

Let's set up the first version of your API service. In Konnect, a Service can
contain many versions, but one spec is always linked to one version.

1. On your Service's overview page, scroll down to **Versions** and
 click **New Version**.

1. Enter a **Version Name**. For this example, enter `v.1`.

    A version name can be any string containing letters, numbers, or characters;
    for example, `1.0.0`, `v.1`, or `version#1`. A Service can have multiple
    versions.

1. Select a runtime group.

    You can choose the `default` group to make this version available to all
    users, or if you have one, select a custom group to limit this version to
    a specific group of runtime instances. This determines which entities and
    runtimes the Service version has access to, and who has access to this
    version. _[link off to more info; some of this info should probably be in an intro to this guide]_

    {:.note}
    > **Note:** Applications can only be registered against
    Services in the default runtime group, so if you plan on using
    [application registration](/konnect/dev-portal/applications/application-overview),
    choose `default` in this step.

    Different versions of the same Service can run in different runtime groups.
    The version name is unique within a group:

    * If you create multiple versions in the **same group**, they must have unique names.
    * If you create multiple versions in **different groups**, the versions can have the same name.

1. Click **Create** to save.

The Service version is created in **Published** status by default. This means
that if you publish the Service to the Dev Portal, this version will be published
along with it.

If you don't want the version to be published yet, you can set the version to a
different [stage in its lifecycle](/link to version lifecycle doc).

## Summary and Next Steps

In this section, you added a Service named `example_service` with the version
`v.1`.

Next, go on to [implement the service version](/konnect/getting-started/implement-service).
