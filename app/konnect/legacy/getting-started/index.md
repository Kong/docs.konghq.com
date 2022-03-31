---
title: Get started with Konnect Cloud
no_version: true
---

## Quickstart guide

New to {{site.konnect_saas}}? Get started with the basics through the web app:

1.  **Set up a runtime connection**:

    Set up a runtime and connect it to your account. Your first runtime
    connection gives you a data plane for proxying traffic.

    Start with a data plane proxy so that when your service configuration is
    ready, your services are immediately connected, configured,
    and available for testing.

    [Set up a runtime connection &gt;](/konnect/legacy/getting-started/configure-runtime)


2.  **Create a service**:

    Catalog a new service using the {{site.konnect_short_name}} ServiceHub.

    Using ServiceHub, you can catalog, manage, and track every service in your
    entire architecture. In this step, you create the first version of a service,
    adding the first entry to your catalog.

    [Create a service &gt;](/konnect/legacy/getting-started/configure-service)

3.  **Implement the new service**:

    Attach the new {{site.konnect_short_name}} service to an upstream service
    and define a route.

    After you've configured a service and the runtime proxy is ready, testing
    is the next step. Here you set up a route to a mocking API service,
    then proxy traffic through the route.

    [Implement the service &gt;](/konnect/legacy/getting-started/implement-service)

## Get started with declarative config

You can manage entities in your {{site.konnect_saas}} org using configuration
files instead of the GUI or admin API commands. With decK, Kong's declarative
configuration management tool, you can create, update,
compare, and synchronize configuration as part of an automation pipeline.

[Manage configuration with decK &gt;](/konnect/legacy/getting-started/declarative-config)
