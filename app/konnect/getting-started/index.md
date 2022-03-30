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

    [Set up a runtime connection &gt;](/konnect/getting-started/configure-runtime)


2.  **Create a service**:

    Catalog a new service using the {{site.konnect_short_name}} ServiceHub.

    Using ServiceHub, you can catalog, manage, and track every service in your
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


4. **Publish the service to Dev Portal**

    Set up a sample API spec and description for the {{site.konnect_short_name}}
    service and publish the service to the Dev Portal.

    [Publish the service &gt;](/konnect/getting-started/publish-service)

## Get started with an API spec

Have an OpenAPI spec and want to share your API with developers? Get started by
using ServiceHub to publish and manage your spec:

1. **Upload your docs to Konnect**

    Through the ServiceHub, you can create and version Konnect Services to manage
    API documentation. Upload a markdown file to describe your Service, and
    add an OpenAPI spec for any version of the Service.

    [Create a Service and import docs &gt;](/konnect/getting-started/spec/service/)

2. **Implement the Service**

    Attach the Service to an upstream application
    and define a route to expose the Service for application registration.

    [Implement the Service &gt;](/konnect/getting-started/spec/service/)

3. **Publish to the Dev Portal**

    Publish your Service documentation to the Dev Portal and preview it from
    the developer perspective.

    [Publish the docs &gt;](/konnect/getting-started/spec/service/)

4. **Register an application**

    Expose your Service to developers and register an application
    against the Service.

    [Expose service and register an application &gt;](/konnect/getting-started/spec/service/)
