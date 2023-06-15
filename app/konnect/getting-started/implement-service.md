---
title: Proxy and Test a Service
---

Create a {{site.konnect_short_name}} service to catalog your APIs. In this guide, you will create, proxy, and test a gateway service using Runtime Manager in {{site.konnect_short_name}}. 

When you create a service, you also specify the route to it. This route,
combined with the proxy URL for the service, will lead to the endpoint
specified in the API product deployment.

## Prerequisites

If you're following the {{site.konnect_short_name}} quickstart guide,
make sure you have
[set up a runtime](/konnect/getting-started/configure-runtime).

## Create a service in Runtime Manager

<!--add steps here-->

## Create a route in Runtime Manager

<!--add steps here-->

## Verify your configuration

<!--add steps here-->

## Summary and next steps

In this section, you added a service named `example_service` with the route `/mock`. This means if an HTTP
request is sent to the {{site.base_gateway}} node and it matches route `/mock`, that
request is sent to `http://mockbin.org`.

Next, [productize your service with an API product](/konnect/getting-started/configure-service/).
