---
title: Health Check
content_type: tutorial
---

This tutorial will guide you through the process of using the new Node Readiness Endpoint, which provides a more reliable and simple way to determine if Kong is ready to serve user requests.

To put it simply, health check endpoint will return a `200 OK` response when Kong is ready, or a `503 Service Unavailable` response when it's not. This is useful for load balancers and other tools that need to monitor the readiness of Kong instances.

Note that the readiness endpoint does not return detailed node health information such as the
amount of memory Kong node is using. You might want to check out the [`/status` API](/gateway/{{page.kong_version}}/admin-api/#retrieve-node-status) as well.

## Prerequisites

* Kong installed
* Basic understanding of Kong configuration and deployment modes (Traditional, DB-less, and Hybrid)

## Understanding the Node Readiness Endpoint

Before diving into the steps, it's important to understand the purpose of the Node Readiness Endpoint and how it determines whether a Kong instance is ready or not.

### Traditional mode

In Traditional mode, the conditions that must be fulfilled simultaneously for the traditional mode are: 

1. Successful connection to the database
2. Successful initial build of all routers for all workers
3. Successful initial build of all plugin iterators for all workers

### DB-less mode (`data_plane` role)

In DB-less mode, the endpoint returns 200 OK when all of the following conditions are met:

1. The current configuration hash is not nil and not all zeros
2. Successful initial build/rebuild of all routers for all workers
3. Successful initial build/rebuild of all plugin iterators for all workers

## Configuring the Status Endpoint

To configure the Status Endpoint in your Kong instance, follow these steps:

1. Ensure that Kong is setup.
2. Open the Kong configuration file (e.g., `kong.conf` or `kong.yml`).
3. Make sure the Status API is enabled by including the following line:

    ```conf
    status_listen = 0.0.0.0:8100
    ```

    This will make the Status API listen on port 8100. You can change the port number to any available port on your system.

4. Save the configuration file and restart Kong to apply the changes.

    ```shell
    kong reload
    ```
    
You can also use `KONG_STATUS_LISTEN` environment variable to configure it.

## Using the Status Endpoint

Once you've configured the Status Endpoint, you can send requests to it to check the readiness of your Kong instance.

1. Send a GET request to the `/status/ready` endpoint. Replace `<status-api-host>` with the appropriate host for your Status API server, including the port number:

    ```shell
    curl -I <status-api-host>/status/ready
    ```

2. If the response is `200 OK`, your Kong instance is ready to serve requests. If the response is `503 Service Unavailable`, Kong does not yet have a valid configuration.

## Updating Readiness Probes

If you're using Kubernetes or Helm, you may need to update the readiness probe configuration to use the new Status Endpoint. Modify the `readinessProbe` section in your configuration file to look like this:

```yaml
readinessProbe:
    httpGet:
        path: /status/ready
        port: 8100
    initialDelaySeconds: 10
    periodSeconds: 5
```

Make sure to replace the port number with the one you configured for the Status API.

## See also

For more information on Kong and related topics, check out the following resources:

* [Kong Admin API Documentation](https://docs.konghq.com/gateway/latest/admin-api/)
* [Get Started with Kong Ingress Controller](https://docs.konghq.com/kubernetes-ingress-controller/latest/deployment/)
* [Kong Helm Chart](https://github.com/Kong/charts/tree/main/charts/kong)
