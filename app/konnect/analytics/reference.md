---
title: Reports Reference
content_type: reference
---

### Route entity format

In custom reports, the route entity name is composed of the following elements:

```
ROUTE_NAME|FIRST_FIVE_UUID_CHARS (CONTROL_PLANE_NODE)
```

For example, for a route entity named `example_route (default)`:
* `example_route` is the route name
* `default` is the name of the control plane.

Or, if your route doesn't have a name, it might look like this:
`DA58B (default)`

Where `DA58B` are the first five characters of its UUID and `default` is the name of the control plane.

{:.note}
> **Note**: If you see a route with `*` and the last five digits of the UUID, like `*DA58B`, this represents the data of a deleted route.

### API product version entity format

The API product version name isn't unique across an organization. To identify the entity you need, the API product version entity name is composed of the following elements:

```
KONNECT_API_PRODUCT_NAME - API_PRODUCT_VERSION (CONTROL_PLANE_NAME)
```

For example, for an API product version entity named `Account - v1 (dev)`:
* `Account` is the {{site.konnect_short_name}} API product name
* `v1` is the API product version
* `dev` is the name of the control plane.

