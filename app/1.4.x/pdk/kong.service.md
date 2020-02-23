---
title: kong.service
pdk: true
toc: true
---

## kong.service

The service module contains a set of functions to manipulate the connection
 aspect of the request to the Service, such as connecting to a given host, IP
 address/port, or choosing a given Upstream entity for load-balancing and
 healthchecking.



### kong.service.set_upstream(host)

Sets the desired Upstream entity to handle the load-balancing step for
 this request.  Using this method is equivalent to creating a Service with a
 `host` property equal to that of an Upstream entity (in which case, the
 request would be proxied to one of the Targets associated with that
 Upstream).

 The `host` argument should receive a string equal to that of one of the
 Upstream entities currently configured.


**Phases**

* access

**Parameters**

* **host** (string):

**Returns**

1.  `boolean|nil` `true` on success, or `nil` if no upstream entities
 where found

1.  `string|nil`  An error message describing the error if there was
 one.



**Usage**

``` lua
local ok, err = kong.service.set_upstream("service.prod")
if not ok then
  kong.log.err(err)
  return
end
```

[Back to TOC](#table-of-contents)


### kong.service.set_target(host, port)

Sets the host and port on which to connect to for proxying the request.
 Using this method is equivalent to ask Kong to not run the load-balancing
 phase for this request, and consider it manually overridden.
 Load-balancing components such as retries and health-checks will also be
 ignored for this request.

 The `host` argument expects a string containing the IP address of the
 upstream server (IPv4/IPv6), and the `port` argument must contain a number
 representing the port on which to connect to.


**Phases**

* access

**Parameters**

* **host** (string):
* **port** (number):

**Usage**

``` lua
kong.service.set_target("service.local", 443)
kong.service.set_target("192.168.130.1", 80)
```

[Back to TOC](#table-of-contents)


### kong.service.set_tls_cert_key(chain, key)

Sets the client certificate used while handshaking with the Service.

 The `chain` argument is the client certificate and intermediate chain (if any)
 returned by functions such as [ngx.ssl.parse\_pem\_cert](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ssl.md#parse_pem_cert).

 The `key` argument is the private key corresponding to the client certificate
 returned by functions such as [ngx.ssl.parse\_pem\_priv\_key](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ssl.md#parse_pem_priv_key).


**Phases**

* `rewrite`, `access`, `balancer`

**Parameters**

* **chain** (cdata):  The client certificate chain
* **key** (cdata):  The client certificate private key

**Returns**

1.  `boolean|nil` `true` if the operation succeeded, `nil` if an error occurred

1.  `string|nil` An error message describing the error if there was one.


**Usage**

``` lua
local chain = assert(ssl.parse_pem_cert(cert_data))
local key = assert(ssl.parse_pem_priv_key(key_data))

local ok, err = tls.set_cert_key(chain, key)
if not ok then
  -- do something with error
end
```

[Back to TOC](#table-of-contents)

