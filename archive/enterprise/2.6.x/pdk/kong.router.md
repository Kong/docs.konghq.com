---
title: kong.router
pdk: true
toc: true
---

## kong.router

Router module
 A set of functions to access the routing properties of the request.



### kong.router.get_route()

Returns the current `route` entity.  The request was matched against this
 route.


**Phases**

* access, header_filter, body_filter, log

**Returns**

* `table` the `route` entity.


**Usage**

``` lua
if kong.router.get_route() then
  -- routed by route & service entities
else
  -- routed by a legacy API entity
end
```

[Back to top](#kongrouter)


### kong.router.get_service()

Returns the current `service` entity.  The request will be targetted to this
 upstream service.


**Phases**

* access, header_filter, body_filter, log

**Returns**

* `table` the `service` entity.


**Usage**

``` lua
if kong.router.get_service() then
  -- routed by route & service entities
else
  -- routed by a legacy API entity
end
```

[Back to top](#kongrouter)
