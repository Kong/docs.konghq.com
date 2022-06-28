---
title: Implement and Test a Service
no_version: true
---

Create a Service implementation to expose your {{site.konnect_short_name}} Service to clients.

When you create an implementation, you also specify the Route to it. This Route,
combined with the proxy URL for the Service, will lead to the endpoint
specified in the Service implementation.

## Prerequisites

If you're following the {{site.konnect_short_name}} quickstart guide,
make sure you have
[configured a Service](/konnect/getting-started/configure-service).

## Implement a Service Version

{% include_cached /md/konnect/implement-service.md %}

## Verify the Implementation

If you used the Docker script to create a container
earlier in [Configure a Runtime](/konnect/getting-started/configure-runtime),
your runtime's default proxy URL is `localhost:8000`.

Enter the proxy URL into your browser’s address bar and append the route path
you just set. The final URL should look something like this:

```
http://localhost:8000/mock
```

If successful, you should see the homepage for `mockbin.org`. On your Service
Version overview page, you’ll see a record for status code 200. This might
take a few moments.

And that's it! You have your first service set up, running, and routing
traffic proxied through a {{site.base_gateway}} runtime.

## Summary and Next Steps

To summarize, in this topic you:

* Implemented the Service version `v1` with the Route `/mock`. This means if an HTTP
request is sent to the {{site.base_gateway}} node and it matches route `/mock`, that
request is sent to `http://mockbin.org`.
* Abstracted a backend/upstream service and put a route of your choice on the
front end, which you can now give to clients to make requests.

Next, [publish the Service to the Dev Portal](/konnect/getting-started/publish-service/)
and test out the Portal from the perspective of a developer.
