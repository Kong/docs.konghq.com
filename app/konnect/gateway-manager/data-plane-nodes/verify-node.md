---
title: Verify a Data Plane Node
content_type: how-to
---

You can test whether your data plane nodes are running using the following methods.

## Access services using the proxy URL

By default, {{site.base_gateway}} uses port `8000` for the proxy, taking incoming
traffic from consumers, and forwarding it to upstream services.

The default proxy URL is `http://localhost:8000`. If you configured a different
host, replace `localhost` with your hostname. Use this URL,
along with any routes you set, to access your services.

For example, to access a service with the route `/mock`, use
`http://localhost:8000/mock`, or `http://example-host:8000/mock`.

## Kubernetes

To proxy traffic through a data plane node running on Kubernetes, you'll need its external IP
address, a port, and a route.

1. To find the address and port, run:

    ```bash
    kubectl get service my-kong-kong-proxy -n kong
    ```

2. In the output, the IP in the `EXTERNAL_IP` column is the access point for
your {{site.konnect_short_name}} services:

    ```bash
    NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
    kong-proxy   LoadBalancer   10.63.254.78   35.233.198.16   80:32697/TCP,443:32365/TCP   22h
    ```

3. With the external IP and one of the available ports (`80` or `443`),
and assuming that you have configured a service with a route,
you can now access your service at `{EXTERNAL_IP}:{PORT}/{ROUTE}`.

    For example, using the values above and a sample route, you now have the
    following:
    * IP: `35.233.198.16`
    * Port: `80`
    * Route: `/mock`

    Putting them together, the end result looks like this:
    `35.233.198.16:80/mock`
