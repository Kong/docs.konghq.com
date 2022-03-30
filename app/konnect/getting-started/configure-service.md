---
title: Configuring a Service
no_version: true
---

Using the [ServiceHub](/konnect/configure/servicehub), you can create, manage, and
implement Konnect Services. Each Service consists of at least one
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

{% include_cached /md/konnect/create-service.md %}

## Create a Service version

{% include_cached /md/konnect/service-version.md %}

## Summary and Next Steps

In this section, you added a Service named `example_service` with the version
`v1`.

Next, go on to [implement the service version](/konnect/getting-started/implement-service).
