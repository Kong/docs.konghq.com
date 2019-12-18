---
name: Route By Cookie
publisher: redhoyasa
categories:
  - traffic-control
type: plugin
desc: Routing user request based on request cookies.
description: |
  Kong has several balancing algorithm options to forward user's request. Even though users will be routed consistently by Kong, we cannot determine which users will go to the certain host. This plugin will route user requests based on request cookies in deterministic way.

  In short, it is like [Route by Header](https://docs.konghq.com/hub/kong-inc/route-by-header/), but it looks at the request cookie instead of request header.
support_url: https://github.com/redhoyasa/kong-plugin-route-by-cookie/issues
source_url: https://github.com/redhoyasa/kong-plugin-route-by-cookie
license_type: MIT
license_url: https://github.com/redhoyasa/kong-plugin-route-by-cookie/blob/master/LICENSE

kong_version_compatibility:
  community_edition:
    compatible:
      - 1.3.x
      - 1.2.x
      - 1.1.x
      - 1.0.x
      - 0.14.x
    incompatible:
  enterprise_edition:
    compatible:
      - 0.36-x
      - 0.35-x
    incompatible:

params:
  name: route-by-cookie
  api_id: True
  service_id: True
  consumer_id: False
  route_id: True
  protocols: ["http", "https"]

  config:
    - name: target_upstream
      required: "yes"
      value_in_examples: "new-upstream"
      description: |
        Kong Upstream which we want to route the request to

    - name: cookie_name
      required: "yes"
      value_in_examples: "COOKIE_NAME"
      description: |
        Cookie name which we will check at

    - name: cookie_val
      required: "yes"
      value_in_examples: "value"
      description: |
        If user's cookie value equals this, Kong will route the user to `target_upstream`.
        Otherwise, it will route the user to the upstream of the service.
---

## Installation

Install the plugin on each node in your Kong cluster via luarocks:

```
luarocks install kong-plugin-route-by-cookie
```

Add to the custom_plugins list in your Kong configuration (on each Kong node):

```
custom_plugins = route-by-cookie
```

## Example

Suppose we want to release the new version of web app to the certain user group. Users from that group will receive cookie `APP_VERSION=2` after they are authenticated.

This section shows how this plugin can achieve our goal.

First, create an upstream and target for old version (v1) and new version (v2):

```bash
$ curl -i -X POST http://kong:8001/upstreams -d name=v1.app.com
HTTP/1.1 201 Created
...
{"created_at":1570979348, ... ,"id":"75034b6e-9d69-43e0-8693-d2cd3f297108"}
```

```bash
$ curl -i -X POST http://kong:8001/upstreams/v1.app.com/targets --data target="v1.host:80"
HTTP/1.1 201 Created
...
{"created_at":1570980098, ... ,"id":"15dc7aba-e9f5-41d2-badd-1ffed9ecb7f0"}
```

```bash
$ curl -i -X POST http://kong:8001/upstreams -d name=v2.app.com
HTTP/1.1 201 Created
...
{"created_at":1570981023, ... ,"id":"25243e4d-bb78-45a7-8ee0-8f6ee830b4d7"}
```

```bash
$ curl -i -X POST http://kong:8001/upstreams/v2.app.com/targets --data target="v2.host:80"
HTTP/1.1 201 Created
...
{"created_at":1570982492, ... ,"id":"49387f3f-591a-4608-a553-2b81fb983ca1"}
```

Next, we will add a service and a route, using the upstream `v1.app.com` as the target:

```bash
$ curl -i -X POST http://kong:8001/services --data protocol=http --data host=v1.app.com --data name=appService
HTTP/1.1 201 Created
...
{"created_at":1570979495, ... ,"id":"67ff6f88-3837-43e2-bc4e-dbb083e2cd5c"}
```

```bash
$ curl -i -X POST http://kong:8001/routes --data "hosts[]=app.com" --data "paths[]=/" --data service.id=67ff6f88-3837-43e2-bc4e-dbb083e2cd5c
HTTP/1.1 201 Created
...
{"id":"d63c22e8-3ce0-4498-a59d-93ff803ba24a", ... ,"created_at":1570979704}
```

At this point, any request to `appService` will be forwarded to the upstream `v1.app.com`.

Let's enable to plugin on `appService` to forward incoming requests from users with cookie `APP_VERSION=2` to the upstream `v2.app.com`:

```bash
$ curl -X POST http://localhost:8001/services/appService/plugins \
    --data "name=route-by-cookie"  \
    --data "config.target_upstream=v2.app.com" \
    --data "config.cookie_name=APP_VERSION" \
    --data "config.cookie_val=2"
...
{"created_at":1570980190, ... ,"id":"f3964aa9-bd3f-4044-94cb-49259e3e2349"}
```

Now any user with cookie `APP_VERSION=2` will be routed to `v2.app.com`. If the cookie value does not match the cookie value defined in config, the request will not be forwarded to the target upstream.
