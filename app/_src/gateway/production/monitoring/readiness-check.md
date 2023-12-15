---
title: Readiness Check
content_type: tutorial
---

This tutorial guides you through the process of using the Node Readiness endpoint, which provides a reliable way to determine if {{site.base_gateway}} is ready to serve user requests.

The readiness check endpoint returns a `200 OK` response when {{site.base_gateway}} is ready, or a `503 Service Temporarily Unavailable` response when it's not. This is useful for load balancers and other tools that need to monitor the readiness of Kong instances. When Kong is not ready, the endpoint responds back with a `message` field with the reason for unreadiness. This can be helpful to debug situations where the user expects that the node should be ready but is not.

{:.note}
> **Note:**  The readiness endpoint does not return detailed information about the node status.

## Prerequisites

* {{site.base_gateway}}
* A basic understanding of {{site.base_gateway}} configuration and deployment modes (traditional, DB-less, and hybrid)

## Understanding the Node Readiness endpoint

Before diving into the steps, it's important to understand the purpose of the Node Readiness endpoint and how it determines whether a Kong instance is ready or not.

### Traditional mode

In traditional mode, the endpoint returns `200 OK` when all of the following conditions are met:

1. Successful connection to the database
2. All Kong workers are ready to route requests
3. All routes and services have their plugins ready to process requests

### Hybrid mode (`data_plane` role) or DB-less mode

In Hybrid mode (`data_plane` role) or DB-less mode, the endpoint returns `200 OK` when the following conditions are met:

1. Kong has loaded a valid and non-empty config (`kong.yaml`)
2. All Kong workers are ready to route requests
3. All routes and services have their plugins ready to process requests

### Hybrid mode (`control_plane` role)

In Hybrid Mode (`control_plane` role), this endpoint returns `200 OK` when the following condition is met:

1. Successful connection to the database

## Enabling the Status endpoint

In order to use the Node Readiness endpoint, make sure that you have enabled the Status API server (disabled by default) via the [`status_listen`](/gateway/latest/reference/configuration/#status_listen) configuration parameter.

Example `kong.conf`:

```conf
status_listen = 0.0.0.0:8100
```

## Using the Node Readiness endpoint

Once you've enabled the Node Readiness endpoint, you can send a GET request to check the readiness of your {{site.base_gateway}} instance:

```sh
# Replace `localhost:8001` with the appropriate host and port for
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


## Updating Readiness Probes

If you're using Kubernetes or Helm, you may need to update the readiness probe configuration to use the new Node Readiness endpoint. Modify the `readinessProbe` section in your configuration file to look like this:

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


## See also

For more information on Kong and related topics, check out the following resources:

* [Kong Admin API Documentation](/gateway/latest/admin-api/)
* [Get Started with {{site.kic_product_name}}](/kubernetes-ingress-controller/latest/deployment/overview/)
* [Kong Helm Chart](https://github.com/Kong/charts/tree/main/charts/kong)
