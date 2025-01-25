---
title: Get Started
description: Learn how to install decK and use it to configure Kong Gateway
content_type: how-to
---

This page teaches you how to use decK to create a service, route, plugins and consumers. It uses the `deck gateway apply` command to build the configuration up incrementally. At any point, you can run `deck gateway dump` to see the entire configuration of {{ site.base_gateway }} at once.

## Prerequisites

Before working through this guide, ensure that you have {{ site.base_gateway }} running and decK installed.

### Run Kong Gateway

The quickest way to run {{ site.base_gateway }} is using the quickstart script:

```bash
curl -Ls https://get.konghq.com/quickstart | bash
```

### Install decK

To complete this guide, you'll need decK v1.43.0 or above [installed](/deck/install/).

If you don't have decK installed, copy the following line in to your terminal to run decK using Docker for the purposes of this guide.

```bash
alias deck='docker run --rm -v .:/files -w /files -e DECK_KONG_ADDR=http://host.docker.internal:8001 kong/deck'
```

## Create a Service

You can use decK to configure a service by providing a `name` and a `url`. Any requests made to this service will be proxied to http://httpbin.konghq.com.

```bash
echo '_format_version: "3.0"
services:
 - name: example-service
   url: http://httpbin.konghq.com' | deck gateway apply
```

## Create a Route

To access this service, you need to configure a route. Create a route that matches incoming requests that start with `/`, and attach it to the service that was previously created by specifying `service.name`:

```bash
echo '_format_version: "3.0"
routes:
  - name: example-route
    service: 
      name: example-service
    paths:
      - "/"' | deck gateway apply
```

You can now make a HTTP request to your running {{ site.base_gateway }} instance and see it proxied to HTTPBin:

```bash
curl http://localhost:8000/anything
```

## Add Rate Limiting

At this point {{ site.base_gateway }} is a transparent layer that proxies requests to the upstream HTTPBin instance. Let's add the [rate limiting](/hub/rate-limiting/) plugin to make sure that people only make five requests per minute.

```bash
echo '_format_version: "3.0"
plugins:
  - name: rate-limiting
    service: example-service
    config:
      minute: 5
      limit_by: consumer
      policy: local' | deck gateway apply
```

To see this in action, make six requests in rapid succession by pasting the following in to your terminal:

```bash
for _ in {1..6}; do 
  curl http://localhost:8000/anything
done
```

## Add Authentication

You may have noticed that the rate limiting plugin used the `limit_by: consumer` configuration option. This means that each uniquely identified consumer is allowed 5 requests per minute.

To identify a consumer, let's add the [key auth plugin](/hub/key-auth/) and create a test user named `alice`:

```bash
echo '_format_version: "3.0"
plugins:
  - name: key-auth
    service: example-service
consumers:
  - username: alice
    keyauth_credentials:
      - key: hello_world' | deck gateway apply
```

After applying the `key-auth` plugin, you need to provide the `apikey` header to authenticate your request:

```bash
curl http://localhost:8000/anything -H 'apikey: hello_world'
```

If you make a request without the authentication header, you will see a `No API key found in request` message.

## See your decK file

This page provided each configuration snippet separately to focus on what each snippet provides. For production usage, you should apply the whole configuration each time.

To export the complete configuration, run `deck gateway dump > kong.yaml`, then open `kong.yaml` in your favorite editor.

Try changing Alice's authentication key to `test` and then run `deck gateway sync kong.yaml` to sync the entire configuration. You'll see the following output:

```
creating key-auth test for consumer alice
deleting key-auth world for consumer alice
Summary:
  Created: 1
  Updated: 0
  Deleted: 1
```

Congratulations! You just went from zero to a configured {{ site.base_gateway }} using deck in no time at all.