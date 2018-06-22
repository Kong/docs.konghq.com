---
title: kong.service
---

# kong.service

The service module contains a set of functions to manipulate the connection
 aspect of the request to the Service, such as connecting to a given host, IP
 address/port, or choosing a given Upstream entity for load-balancing and
 healthchecking.

## Table of Contents


### [Functions](#Functions)

* [kong.service.set_target(host, port)](#kong_service_set_target)
* [kong.service.set_upstream(host)](#kong_service_set_upstream)


## <a name="Functions"></a>Functions



### <a name="kong_service_set_target"></a>kong.service.set_target(host, port)

Sets the host and port on which to connect to for proxying the request.  ]]
 Using this method is equivalent to ask Kong to not run the load-balancing
 phase for this request, and consider it manually overriden. Load-balancing
 components such as retries and health-checks will also be ignored for this
 request.

 The `host` argument expects a string containing the IP address of the upstream
 server (IPv4/IPv6), and the `port` argument must contain a number representing
 the port on which to connect to.

**Phases**

* `access`

**Parameters**

* **host**(`string`):
* **port**(`number`):

**Usage**


``` lua
kong.service.set_target("service.local", 443)
kong.service.set_target("192.168.130.1", 80)
```


### <a name="kong_service_set_upstream"></a>kong.service.set_upstream(host)

Sets the desired Upstream entity to handle the load-balancing step for this
 request.  Using this method is equivalent to creating a Service with a `host`
 property equal to that of an Upstream entity (in which case, the request
 would be proxied to one of the Targets associated with that Upstream).

 The `host` argument should receive a string equal to that of one of the
 Upstream entities currently configured.


**Phases**

* `access`

**Parameters**

* **host**(`string`):

**Returns**

1. `boolean|nil` `true` on success, or `nil` if no upstream entities where found

1. `string|nil` An error message describing the error if there was one.


**Usage**


``` lua
local ok, err = kong.service.set_upstream("service.prod")
if not ok then
  kong.log.err(err)
  return
end
```

