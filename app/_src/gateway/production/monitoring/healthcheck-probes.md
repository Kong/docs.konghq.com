---
title: Health Check Probes
content_type: tutorial
---

This tutorial guides you through the process of using the node readiness endpoint, which provides a reliable way to determine if {{site.base_gateway}} is ready to serve user requests.

The readiness check endpoint returns a `200 OK` response when {{site.base_gateway}} is ready, or a `503 Service Temporarily Unavailable` response when it's not. This is useful for load balancers and other tools that need to monitor the readiness of Kong instances. When Kong is not ready, the endpoint responds back with a `message` field with the reason for unreadiness. This can be helpful to debug situations where the user expects that the node should be ready but is not.

{:.note}
> **Note:** The readiness endpoint does not return detailed information about the node status.

## Types of health checks

For each {{site.base_gateway}} node, there are two distinct health checks (also known as "probes"):

* **Liveness**: The `/status` endpoint responds with a `200 OK` status if Kong is running. The request will fail either with a `500 Internal Server Error` or no response if Kong is not running. You can send a GET request to check the liveness of your {{site.base_gateway}} instance:
  
  ```sh
  # Replace localhost:8100 with the appropriate host and port for
  # your Status API server
  
  curl -i http://localhost:8100/status
  ```

* **Readiness**: The `/status/ready` endpoint responds with a `200 OK` status if Kong has successfully loaded a valid configuration and is ready to proxy traffic. The request will fail either with a `500 Internal Server Error` or no response if Kong is not ready to proxy traffic yet. You can send a GET request to check the readiness of your {{site.base_gateway}} instance:
  
  ```sh
  # Replace localhost:8100 with the appropriate host and port for
  # your Status API server
  
  curl -i http://localhost:8100/status/ready
  ```

These two types of health checks for {{site.base_gateway}} are modeled on how [Kubernetes defines](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) health check probes.

We strongly recommend that a component (that is, a load balancer) perform the readiness health check before sending traffic. This ensures that a {{site.base_gateway}} node has not only successfully started up but has also finished loading up the configuration and is ready to receive proxy traffic. 

The liveness health check may return a 200 OK response before the readiness health check does. 
Even if {{site.base_gateway}} is running, it may still be loading the full configuration, which means it is live but not ready.
If a component only monitors the liveness probe to decide when to send traffic to {{site.base_gateway}}, there will be a short period of time where requests will be met with a `404 Not Found` response before the {{site.base_gateway}} is ready to proxy traffic. 
We recommend using the readiness probe over the liveness probe, especially in production environments.

## Understanding the node readiness endpoint

Before diving into the steps, it's important to understand the purpose of the node readiness endpoint and how it determines whether a Kong instance is ready or not. The endpoint acts differently depending on the node type.

{% navtabs %}
{% navtab Traditional mode %}

In [traditional mode](/gateway/{{page.release}}/production/deployment-topologies/traditional/), the endpoint returns `200 OK` when all of the following conditions are met:

1. Successful connection to the database
2. All Kong workers are ready to route requests
3. All routes and services have their plugins ready to process requests

{% endnavtab %}
{% navtab Hybrid mode (data plane role) or DB-less mode %}

In [hybrid mode](/gateway/{{page.release}}/production/deployment-topologies/hybrid-mode/) (`data_plane` role) or [DB-less mode](/gateway/{{page.release}}/production/deployment-topologies/db-less-and-declarative-config/), the endpoint returns `200 OK` when the following conditions are met:

1. Kong has loaded a valid and non-empty config (`kong.yaml`)
2. All Kong workers are ready to route requests
3. All routes and services have their plugins ready to process requests

{% endnavtab %}
{% navtab Hybrid mode (control plane role) %}

In [hybrid mode](/gateway/{{page.release}}/production/deployment-topologies/hybrid-mode/) (`control_plane` role), this endpoint returns `200 OK` when the following condition is met:

1. Successful connection to the database

{% endnavtab %}
{% endnavtabs %}

## Enabling the node readiness endpoint

To use the node readiness endpoint, make sure that you have enabled the Status API server (disabled by default) via the [`status_listen`](/gateway/latest/reference/configuration/#status_listen) configuration parameter.

Example `kong.conf`:

```conf
status_listen = 0.0.0.0:8100
```

{:.note}
> **Note:** Readiness probes should be used on every node within the cluster, including standalone, control plane, and data plane nodes. Checking only one node in a cluster is insufficient.

## Using the node readiness endpoint

Once you've enabled the node readiness endpoint, you can send a GET request to check the readiness of your {{site.base_gateway}} instance:

```sh
# Replace localhost:8100 with the appropriate host and port for
# your Status API server

curl -i http://localhost:8100/status/ready
```

If the response code is `200`, the {{site.base_gateway}} instance is ready to serve requests:

```http
HTTP/1.1 200 OK
Date: Thu, 04 May 2023 22:00:52 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Access-Control-Allow-Origin: *
Content-Length: 19
X-Kong-Admin-Latency: 3
Server: kong/3.3.0

{
  "message": "ready"
}
```

If the response code is `503`, the {{site.base_gateway}} instance is unhealthy and/or not yet ready to serve requests:

```http
HTTP/1.1 503 Service Temporarily Unavailable
Date: Thu, 04 May 2023 22:01:11 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Access-Control-Allow-Origin: *
Content-Length: 43
X-Kong-Admin-Latency: 3
Server: kong/3.3.0

{
  "message": "failed to connect to database"
}
```

```http
HTTP/1.1 503 Service Temporarily Unavailable
Date: Thu, 04 May 2023 22:06:58 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Access-Control-Allow-Origin: *
Content-Length: 70
X-Kong-Admin-Latency: 16
Server: kong/3.3.0

{
  "message": "no configuration available (empty configuration present)"
}
```

### Using readiness probes in Kubernetes

If you're using Kubernetes or Helm, you may need to update the readiness probe configuration to use the new node readiness endpoint. Modify the `readinessProbe` section in your configuration file to look like this:

```yaml
readinessProbe:
    httpGet:
        path: /status/ready
        # Make sure to replace the port number with the one you
        # configured for the Status API Server.
        port: 8100
    initialDelaySeconds: 10
    periodSeconds: 5
```

{:.note}
> **Note:** Failure to set an `initialDelaySeconds` may result in {{site.base_gateway}} entering a crash loop, as it requires a short time to fully load the configuration. The time to delay can depend on the size of the configuration.

### Using a readiness check in version 3.2 or lower

The `/status/ready` endpoint was added in version 3.3, so prior versions don't benefit from this built-in readiness endpoint. 
We recommend the following workaround for those versions:

1. Configure a new route in {{site.base_gateway}} with the path uniquely set for this purpose. This route doesn't require a service.

   For example, you could use the path `/health/ready`.
2. Configure the Request Termination plugin to respond to requests on that route with a HTTP 200 status code.

{:.note}
> **Note:** In this workaround, the port to send health check requests to is the proxy port (8000 & 8443 by default) instead of the status API port.

## What isn't covered by health checks?

A health check probe doesn't take the following into account:
* If {{site.base_gateway}} is performing optimally or not
* If {{site.base_gateway}} is throwing intermittent failures for any reason
* If {{site.base_gateway}} is throwing errors due to third-party systems like DNS, cloud provider outages, network failures, and so on
* If any upstream services are throwing errors or responding too slowly

## See also

For more information on Kong and related topics, check out the following resources:

* [Health Check and Monitoring Overview](/gateway/latest/production/monitoring/)
* [Kong Admin API Documentation](/gateway/latest/admin-api/)
* [Get Started with {{site.kic_product_name}}](/kubernetes-ingress-controller/latest/deployment/overview/)
* [Kong Helm Chart](https://github.com/Kong/charts/tree/main/charts/kong)
* [Kong Hybrid Mode](/gateway/latest/production/deployment-topologies/hybrid-mode/)
