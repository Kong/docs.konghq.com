---
title: Get started with Konnect
no_version: true
---

## Quickstart guide

New to {{site.konnect_saas}}? Get started with the basics through the web app:

1. **Create a {{site.konnect_short_name}} account**:

    [Create an account &gt;](/konnect/getting-started/access-account)

1.  **Set up a runtime connection**:

    Set up a runtime and connect it to your account. Your first runtime
    connection gives you a data plane for proxying traffic.

    Start with a data plane proxy so that when your service configuration is
    ready, your services are immediately connected, configured,
    and available for testing.

    [Set up a runtime connection &gt;](/konnect/getting-started/configure-runtime)


2.  **Create a service**:

    Catalog a new service using the {{site.konnect_short_name}} Service Hub.

    Using Service Hub, you can catalog, manage, and track every service in your
    entire architecture. In this step, you create the first version of a service,
    adding the first entry to your catalog.

    [Create a service &gt;](/konnect/getting-started/configure-service)

3.  **Implement the new service**:

    Attach the new {{site.konnect_short_name}} service to an upstream service
    and define a route.

    After you've configured a service and the runtime proxy is ready, testing
    is the next step. Here you set up a route to a mocking API service,
    then proxy traffic through the route.

    [Implement the service &gt;](/konnect/getting-started/implement-service)

## Share APIs and enable development

Ready to share your API with developers?
Use the Service Hub to manage your API documentation, then publish it to the Dev Portal:

1. **Upload your spec to {{site.konnect_short_name}} and publish to Dev Portal**

    Upload a markdown file to describe your service, and add an OpenAPI spec for any version of the service.
    Then, publish your service documentation to the Dev Portal and preview it from the developer perspective.

    [Import docs and publish a service &gt;](/konnect/getting-started/publish-service/)

1. **Register an application**

    Expose your service to developers and register an application
    against the service.

    [Expose service and register an application &gt;](/konnect/getting-started/app-registration/)
