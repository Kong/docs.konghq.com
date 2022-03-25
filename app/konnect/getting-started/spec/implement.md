---
title: Implement a Service Version with Kong Gateway
no_version: true
---

Your Service is now shared with developers, and they can access the API spec
documentation. Next, you can let your developers interact with the Konnect
Service directly by building applications that can consume the Service.

To do this, first you need to implement the Service to expose it to clients.

## Prerequisites

If you're following the {{site.konnect_short_name}} API spec guide,
make sure you have [imported API docs into Konnect](/konnect/getting-started/spec/service/).

## Implement a Service Version

{% include_cached /md/konnect/implement-service.md %}

## Set up a Kong Gateway instance

{% include_cached /md/konnect/docker-runtime.md %}

## Verify the Implementation

The default proxy URL for this runtime is `http://localhost:8000`.

Enter the proxy URL into your browser’s address bar and append the route path
you just set. The final URL should look something like this:

```
http://localhost:8000/mock
```

If successful, you should see the homepage for `mockbin.org`. On your Service
Version overview page, you’ll see a record for status code 200. This might
take a few moments.

## Summary and Next Steps

To summarize, in this topic you:

* Implemented the Service version `v1` with the Route `/mock`. This means if an HTTP
request is sent to the {{site.base_gateway}} node and it matches route `/mock`, that
request is sent to `http://mockbin.org`.
* Abstracted a backend/upstream service and put a route of your choice on the
front end, which you can now give to clients to make requests.

Next, [publish your Konnect Service to a Dev Portal instance](/konnect/getting-started/spec/publish/).
