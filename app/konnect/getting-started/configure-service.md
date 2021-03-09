---
title: Configuring a Service
no_version: true
---

Using the [ServiceHub](/konnect/servicehub), you can create, manage, and
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

## Add a Service and Version

1. From the left navigation menu, click **Services** to open ServiceHub.

2. Click **Add New Service**.

3. Enter a **Service Name**. For this example, enter `example_service`.

    A Service name can be any string containing letters, numbers, or characters;
    for example, `service_name`, `Service Name`, or `Service-name`.

4. Enter a **Version Name**. For this example, enter `v.1`.

    A version name can be any string containing letters, numbers, or characters;
    for example, `1.0.0`, `v.1`, or `version#1`. A Service can have multiple
    versions.

5. (Optional) Enter a **Description**.

6. Click **Create**.

    A new Service is created and the page automatically redirects back to the
    **example_service** overview page.


## Summary and Next Steps

In this section, you added a Service named `example_service` with the version
`v.1`.

Next, go on to [implement the service version](/konnect/getting-started/implement-service).
