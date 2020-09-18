---
title: Configuring a Service
no_search: true
no_version: true
beta: true
---

## What are Services, Service Versions, and Implementations?
In Kong Gateway, Service and Route objects let you expose your Services to
clients. {{site.konnect_product_name}} (Konnect) does the same, but at a more
granular level, letting you expand that same Service into a versioned entity,
then implement the Versions and Routes as needed.

Each Service entity is an abstractions of each of your own upstream services,
for example, a data transformation microservice or a billing API.

In Konnect, a Service breaks down into multiple components:
* **Service Entity**, or Service Package, is the wrapper for the versions and
implementations.
* **Service Version** is one instance, or implementation of the
Service with a unique configuration. Each version can have different
configurations, set up for a RESTful API, gPRC endpoint, GraphQL endpoint, etc.
* **Service Implementation** is the concrete, runnable incarnation of a Service
Version. Each Service Version can have one implementation.

The main attribute of a Service Version is its URL, where the service
listens for requests. You can specify the URL with a single string, or by
specifying its protocol, host, port, and path individually.

## What are Routes?

Before you can start making requests against the Service Version, you will
need to add a Route to it. Routes determine how (and if) requests are sent to
their Services after they reach Kong Gateway. A single Service Version
can have many Routes.

After configuring the Service, Version, Implementation, and its Route(s),
you’ll be able to start making requests through Konnect.

## Add a Service and Version

For the purpose of this example, you’ll create a Service, version it, and
expose the version by creating an implementation pointing to the Mockbin API.
Mockbin is an *echo*-type public website that returns requests back to the
requester as responses.

1. On the Services page, click **Add New Service**.

2. Enter a **Service Name**. For this example, enter `example_service`.

    A Service Name can be any string containing letters, numbers, or characters;
    for example, `service_name`, `Service Name`, or `Service-name`.

3. Enter a **Version Name**. For this example, enter `v.1`.

    A Version Name can be any string containing letters, numbers, or characters;
    for example, `1.0.0`, `v.1`, or `version#1`. A Service can have multiple
    Versions.

4. (Optional) Enter a **Description**.

5. Click **Create**.

    A new Service is created and the page automatically redirects back to the
    **example_service** overview page.

## Implement a Service Version
Create a Service Implementation to expose your service to clients. When you
create an implementation, you also specify the Route to it. This Route,
combined with the proxy URL for the Service, will point to the endpoint
specified in the Service Implementation.

1. On the **example_service** overview, in the Version section, click **v.1**.

2. On the **v.1** overview, click **New Implementation**.

3. In the **Create Implementation** dialog, in step 1, create a new Service
Implementation to associate with your Service Version.

    1. Click the **Add using URL** radio button. This is the default.

    2. In the URL field, enter `http://mockbin.org`.

    3. Use the defaults for the 6 Advanced Fields.

    4. Click **Next**.

4. In step 2, **Add a Route** to add a route to your Service Implementation.

    For this example, enter the following:

    1. For Name, enter `mockbin`.

    2. For Path(s), click **Add Path** and enter `/mock`.

    3. For the remaining fields, use the default values listed.

    4. Click **Create**.

        The **v.1** Service Version overview displays.

        If you want to view the configuration, edit or delete the implementation,
        or delete the version, click the Actions menu.

## Verify the Implementation

1. From the top of the Service Version overview page, copy the **Proxy URL**.

2. Paste the URL into your browser’s address bar and append the route path you
just set. For example:

    ```
    http://konginc1216afah12dp.dev.khcp.kongcloud.io/mock
    ```

    If successful, you should see the homepage for `mockbin.org`. On your Service
    Version overview page, you’ll see a record for status code 200. This might take
    a few moments.

## Summary and Next Steps

In this section, you:

* Added a Service named `example_service` with the version `v.1`.
* Implemented the Service Version with the Route `/mock`. This means if an HTTP
request is sent to the Kong Gateway node and it matches route `/mock`, that
request is sent to `http://mockbin.org`.
* Abstracted a backend/upstream service and put a route of your choice on the
front end, which you can now give to clients to make requests.

Next, go on to [enable a plugin on a Service Version](/konnect/getting-started/enable-service-plugin).
