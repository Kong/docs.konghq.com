---
title: Blue-green Deployments
content_type: tutorial
---

Using the [ring-balancer](/gateway/latest/how-kong-works/load-balancing/#ring-balancer), a blue-green deployment can be easily orchestrated for
a service. Switching target infrastructure only requires a `PATCH` request on a
service to change its `host` value.

Set up the "blue" environment, running version one of the address service:

1. Create an upstream:
    ```bash
    curl -X POST http://localhost:8001/upstreams \
        --data "name=address.v1.service"
    ```

2. Add two targets to the upstream:
    ```sh
    curl -X POST http://localhost:8001/upstreams/address.v1.service/targets \
        --data "target=192.168.34.15:80"
        --data "weight=100"
    curl -X POST http://localhost:8001/upstreams/address.v1.service/targets \
        --data "target=192.168.34.16:80"
        --data "weight=50"
    ```
3. Create a service targeting the Blue upstream:
    ```sh
    curl -X POST http://localhost:8001/services/ \
        --data "name=address-service" \
        --data "host=address.v1.service" \
        --data "path=/address"
    ```

4. Finally, add a route as an entry-point into the service:
    ```sh
    curl -X POST http://localhost:8001/services/address-service/routes/ \
        --data "hosts[]=address.mydomain.com"
    ```

Requests with host header set to `address.mydomain.com` will now be proxied
by {{site.base_gateway}} to the two defined targets. Two-thirds of the requests will go to
`http://192.168.34.15:80/address` (`weight=100`), and one-third will go to
`http://192.168.34.16:80/address` (`weight=50`).

Before deploying version two of the address service, set up the "Green"
environment:

1. Create a new Green upstream for address service v2:
    ```sh
    curl -X POST http://localhost:8001/upstreams \
        --data "name=address.v2.service"
    ```

2. Add targets to the upstream:
    ```sh
    curl -X POST http://localhost:8001/upstreams/address.v2.service/targets \
        --data "target=192.168.34.17:80"
        --data "weight=100"
    curl -X POST http://localhost:8001/upstreams/address.v2.service/targets \
        --data "target=192.168.34.18:80"
        --data "weight=100"
    ```

3. To activate the blue/green switch, we now only need to update the service.
Switch the Service from Blue to Green upstream, v1 -> v2:

    ```bash
    curl -X PATCH http://localhost:8001/services/address-service \
      --data "host=address.v2.service"
    ```

Incoming requests with host header set to `address.mydomain.com` are now
proxied by Kong to the new targets. Half of the requests will go to
`http://192.168.34.17:80/address` (`weight=100`), and the other half will go to
`http://192.168.34.18:80/address` (`weight=100`).

As always, the changes through the {{site.base_gateway}} Admin API are dynamic and take
effect immediately. No reload or restart is required, and no in-progress
requests are dropped.
