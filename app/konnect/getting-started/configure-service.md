---
title: Configuring a Service
no_search: true
no_version: true
beta: true
---

## What are Services, Sevice Versions, and Implementations?

In Kong Gateway, Service and Route objects let you expose your Services to clients. Kong Konnect (Konnect) does the same, but at a more granular level, letting you expand that same Service into a versioned entity, then implement the Versions and Routes as needed.

In Konnect, a Service breaks down into multiple components:
* **Service Object** is the wrapper for the Versions and Implementations.
* **Service Version** is one instance a Service, or implementation of the Service with a unique configuration. Each version can have different configurations, set up for a RESTful API, gPRC endpoint, GraphQL endpoint, etc.
* **Service Implementation** is the concrete, runnable incarnation of a Service Version. Each Service Version can have one Implementation.

The main attribute of a Service Implementation is its URL, where the service listens for requests. You can specify the URL with a single string, or by specifying its protocol, host, port, and path individually.

Before you can start making requests against the Service, you will need to add a Route to it. Routes determine how (and if) requests are sent to their Services after they reach Kong Gateway. A single Service Implementation can have many Routes.

After configuring the Service, Version, Implementation, and its Route(s), you’ll be able to start making requests through Konnect.

### Add a Service and Version
Service entities are abstractions of each of your own upstream services, for example, a data transformation microservice or a billing API.

For the purpose of this example, you’ll create a Service, version it, and expose the version by creating an implementation pointing to the Mockbin API. Mockbin is an “echo” type public website that returns requests back to the requester as responses.

1. On the Services page, click **Add New Service**.
2. Enter a **Service Name**. For this example, enter **example_service**. A Service Name can be any string containing letters, numbers, or characters; for example, service_name, Service Name, or ServiceName.
3. Enter a **Version Name**. For this example, enter **v1**. A Version Name can be any string containing letters, numbers, or characters; for example, 1.0.0, v1, or version#1. A Service can have multiple versions.
4. (Optional) Enter a **Description**.
5. Click **Create**.

A new Service is created and the page automatically redirects back to the example_service Overview page.

### Implement a Service Version
Create a Service Implementation to expose your service to clients. When you create an implementation, you also specify the Route to it. This Route, combined with the proxy URL for the Service, will point to the endpoint specified in the Service Implementation.

1. On the example_service Overview, in the Version section click **v1**.
2. On the **v1** Overview, click **New Implementation**.
3. In the Create Implementation dialog, create a new Service Implementation to associate with your Service Version.
   a. Click **Add using URL**.
   b. In the URL field, enter **http://mockbin.org**.
   c. Use the defaults for the 6 Advanced Fields.
   d. Click **Next**.
4. Click **Add a Route** to add a route to your Service Implementation. For this example, enter the following:
   a. For Name, enter **mockbin**.
   b. For Path(s), click **Add Path** and enter **/mock**.
   c. For the remaining fields, use the default values listed.
   d. Click **Create**. The Version Overview displays.

   If you want to view the configuration, edit or delete the implementation, or delete the version, click the Actions menu.

### Verify the Implementation
1. From the top of the Service Version Overview page, copy the Proxy URL.
2. Paste the URL into your browser’s address bar and append the route path you just set. For example:

http://konginc14dd01dp.dev.khcp.kongcloud.io/mock

If successful, you should see the homepage for mockbin.org. On your Service Version Overview page, you’ll see a record for status code 200. This might take a few moments.

### Next Steps
