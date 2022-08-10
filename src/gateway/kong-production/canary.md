---
title: Canary Deployments
content-type: reference
---

Using the [ring-balancer](/gateway/latest/understanding-kong/loadbalancing/#ring-balancer), target weights can be adjusted granularly, allowing
for a smooth, controlled canary release.

Using a very simple two target example:

```bash
# first target at 1000
$ curl -X POST http://localhost:8001/upstreams/address.v2.service/targets \
    --data "target=192.168.34.17:80"
    --data "weight=1000"

# second target at 0
$ curl -X POST http://localhost:8001/upstreams/address.v2.service/targets \
    --data "target=192.168.34.18:80"
    --data "weight=0"
```

By repeating the requests, but altering the weights each time, traffic will
slowly be routed towards the other target. For example, set it at 10%:

```bash
# first target at 900
$ curl -X POST http://localhost:8001/upstreams/address.v2.service/targets \
    --data "target=192.168.34.17:80"
    --data "weight=900"

# second target at 100
$ curl -X POST http://localhost:8001/upstreams/address.v2.service/targets \
    --data "target=192.168.34.18:80"
    --data "weight=100"
```

The changes through the {{site.base_gateway}} Admin API are dynamic and take
effect immediately. No reload or restart is required, and no in progress
requests are dropped.