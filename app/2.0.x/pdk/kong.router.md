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
local route = kong.router.get_route()
local protocols = route.protocols
```

[Back to TOC](#table-of-contents)


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
  -- routed by a route without a service
end
```

[Back to TOC](#table-of-contents)

