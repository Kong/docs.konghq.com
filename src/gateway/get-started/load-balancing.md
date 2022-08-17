---
title: Configure Load Balancing
---

In this topic, you’ll learn about configuring upstream services, and create multiple targets for load balancing.

If you are following the getting started workflow, make sure you have completed [Secure Services Using Authentication](/gateway/{{page.kong_version}}/get-started/comprehensive/secure-services) before moving on.

## What are Upstreams?

An **Upstream Object** refers to your upstream API/service sitting behind {{site.base_gateway}}, to which client requests are forwarded. In {{site.base_gateway}}, an Upstream Object represents a virtual hostname and can be used to health check, circuit break, and load balance incoming requests over multiple services (targets).

In this topic, you’ll configure the service created earlier (`example_service`) to point to an upstream instead of the host. For the purposes of our example, the upstream will point to two different targets, `httpbin.org` and `mockbin.org`. In a real environment, the upstream will point to the same service running on multiple systems.

Here is a diagram illustrating the setup:

![Upstream targets](/assets/images/docs/getting-started-guide/upstream-targets.png)

## Why load balance across upstream targets?

In the following example, you’ll use an application deployed across two different servers, or upstream targets. {{site.base_gateway}} needs to load balance across both servers, so that if one of the servers is unavailable, it automatically detects the problem and routes all traffic to the working server.

## Configure Upstream Services

In this section, you will create an Upstream named `example_upstream` and add two targets to it.

Call the Admin API on port `8001` and create an Upstream named `example_upstream`:

```sh
curl -X POST http://localhost:8001/upstreams \
  --data name=example_upstream
```
Update the service you created previously to point to this upstream:

```sh
curl -X PATCH http://localhost:8001/services/example_service \
  --data host='example_upstream'
```

Add two targets to the upstream, each with port 80: `mockbin.org:80` and
`httpbin.org:80`:


```sh
curl -X POST http://localhost:8001/upstreams/example_upstream/targets \
  --data target='mockbin.org:80'

curl -X POST http://localhost:8001/upstreams/example_upstream/targets \
  --data target='httpbin.org:80'
```

You now have an Upstream with two targets, `httpbin.org` and `mockbin.org`, and a service pointing to that Upstream.

## Validate the Upstream Services

1. With the Upstream configured, validate that it’s working by visiting the route `http://<localhost:8000/mock` using a web browser or CLI.
2. Continue pinging the endpoint and the site should change from `httpbin` to `mockbin`.

## Summary and next steps

In this topic, you:

* Created an Upstream object named `example_upstream` and pointed the Service `example_service` to it.
* Added two targets, `httpbin.org` and `mockbin.org`, with equal weight to the Upstream.

If you have a {{site.konnect_product_name}} subscription, go on to [Managing Administrative Teams](/gateway/{{page.kong_version}}/get-started/comprehensive/manage-teams).
