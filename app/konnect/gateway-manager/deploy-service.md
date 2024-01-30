---
title: Proxy and Test a Service
---

Create a {{site.konnect_short_name}} Gateway service to proxy your APIs. In this guide, you will create, proxy, and test a gateway service using Gateway Manager in {{site.konnect_short_name}}. 

When you create a service, you also specify the route to it. This route,
combined with the proxy URL for the service, will lead to the endpoint
specified in the API product deployment.

## Prerequisites

If you're following the {{site.konnect_short_name}} quickstart guide,
make sure you have
[configured a data plane node](/konnect/getting-started/configure-data-plane-node).

## Implement a Gateway service

In the {% konnect_icon runtimes %} [**Gateway Manager**](https://cloud.konghq.com/us/gateway-manager), select the **Default** control plane and follow these steps:

1. Select **Gateway Services** from the side navigation bar, then **New Gateway Service**.

1. From the **Add a Gateway Service** dialog, create a new service: 

    1. Enter a unique name for the Gateway service, or
    specify a Gateway service that doesn't yet have a version connected to it.

       For the purpose of this example, enter `example_gateway_service`.

       The name can be any string containing letters, numbers, or the following
       characters: `.`, `-`, `_`, `~`, or `:`. Do not use spaces.

       For example, you can use `example_service`, `ExampleService`, `Example-Service`.
       However, `Example Service` is invalid.

    1. In the **add using upstream URL** field, enter `http://httpbin.org`.

    1. Use the defaults for the remaining fields.

    1. Click **Save**.

1. Add a route to your service implementation by clicking the **Add a Route** button now visible from the Gateway service dashboard.

    For this example, enter the following:

    * **Name**: `httpbin`
    * **Protocols**: `HTTP`, `HTTPS`
    * **Path(s)**: `/mock`

1. Click **Save**.

## Verify the implementation

If you used the Docker script to connect a data plane
earlier in [Configure a data plane node](/konnect/getting-started/configure-data-plane-node/),
your default proxy URL is `localhost:8000`.

Enter the proxy URL into your browser’s address bar and append the route path
you just set. The final URL should look something like this:

```
http://localhost:8000/mock
```

If successful, you should see the homepage for `httpbin.org`. In the Gateway Manager you will now see a **200** responses recorded in the **Analytics** tab.

And that's it! You have your first service set up, running, and routing
traffic proxied through a {{site.base_gateway}} data plane node.

## Summary and next steps

To summarize, in this topic you:

* Implemented a Gateway service `example_gateway_service` and the route `/mock`. This means if an HTTP
request is sent to the {{site.base_gateway}} node and it matches route `/mock`, that
request is sent to `http://httpbin.org`.
* Abstracted a backend/upstream service and put a route of your choice on the
front end, which you can now give to clients to make requests.

Next, [productize your service with an API product](/konnect/getting-started/productize-service/).
