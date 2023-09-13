---
title: Proxy and Test a Service
---

Create a {{site.konnect_short_name}} Gateway service to proxy your APIs. In this guide, you will create, proxy, and test a gateway service using Runtime Manager in {{site.konnect_short_name}}. 

When you create a service, you also specify the route to it. This route,
combined with the proxy URL for the service, will lead to the endpoint
specified in the API product deployment.

## Prerequisites

If you're following the {{site.konnect_short_name}} quickstart guide,
make sure you have
[Configured a runtime](/konnect/getting-started/configure-runtime).

## Implement a Gateway service

In the {% konnect_icon runtimes %} [**Runtime Manager**](https://cloud.konghq.com/us/runtime-manager), select the **Default** runtime group and follow these steps:

1. Select **Gateway Services** from the side navigation bar, then **New Gateway Service**.

1. From the **Add a Gateway Service** dialog, create a new service: 

    1. Enter a unique name for the Gateway service, or
    specify a Gateway service that doesn't yet have a version connected to it.

       For the purpose of this example, enter `example_gateway_service`.

       The name can be any string containing letters, numbers, or the following
       characters: `.`, `-`, `_`, `~`, or `:`. Do not use spaces.

       For example, you can use `example_service`, `ExampleService`, `Example-Service`.
       However, `Example Service` is invalid.

    1. In the **add using upstream URL** field, enter `http://mockbin.org`.

    1. Use the defaults for the remaining fields.

    1. Click **Save**.

1. Add a route to your service implementation by clicking the **Add a Route** button now visible from the Gateway service dashboard.

    For this example, enter the following:

    * **Name**: `mockbin`
    * **Protocols**: `HTTP`, `HTTPS`
    * **Path(s)**: `/mock`

1. Click **Save**.

## Verify the implementation

If you used the Docker script to create a container
earlier in [Configure a Runtime](/konnect/getting-started/configure-runtime/),
your runtime's default proxy URL is `localhost:8000`.

Enter the proxy URL into your browser’s address bar and append the route path
you just set. The final URL should look something like this:

```
http://localhost:8000/mock
```

If successful, you should see the homepage for `mockbin.org`. In the runtime manager you will now see a **200** responses recorded in the **Analytics** tab.

And that's it! You have your first service set up, running, and routing
traffic proxied through a {{site.base_gateway}} runtime.

## Summary and next steps

To summarize, in this topic you:

* Implemented a Gateway service `example_gateway_service` and the route `/mock`. This means if an HTTP
request is sent to the {{site.base_gateway}} node and it matches route `/mock`, that
request is sent to `http://mockbin.org`.
* Abstracted a backend/upstream service and put a route of your choice on the
front end, which you can now give to clients to make requests.

Next, [productize your service with an API product](/konnect/getting-started/productize-service/).
