---
#
#  WARNING: this file was auto-generated by a script.
#  DO NOT edit this file directly. Instead, send a pull request to change
#  https://github.com/Kong/kong/tree/master/kong/pdk
#  or its associated files
#
title: kong.service
pdk: true
toc: true
source_url: https://github.com/Kong/kong/tree/master/kong/pdk/service.lua
---
<!-- vale off -->
The service module contains a set of functions to manipulate the connection
 aspect of the request to the Service, such as connecting to a given host, IP
 address/port, or choosing a given Upstream entity for load-balancing and
 healthchecking.



## kong.service.set_upstream(host)

Sets the desired Upstream entity to handle the load-balancing step for
 this request.  Using this method is equivalent to creating a Service with a
 `host` property equal to that of an Upstream entity (in which case, the
 request would be proxied to one of the Targets associated with that
 Upstream).

 The `host` argument should receive a string equal to the name of one of the
 Upstream entities currently configured.


**Phases**

* access

**Parameters**

* **host** (`string`):

**Returns**

1.  `boolean|nil`:  `true` on success, or `nil` if no upstream entities
 where found

1.  `string|nil`:   An error message describing the error if there was
 one.



**Usage**

``` lua
local ok, err = kong.service.set_upstream("service.prod")
if not ok then
  kong.log.err(err)
  return
end
```



## kong.service.set_target(host, port)

Sets the host and port on which to connect to for proxying the request.
 Using this method is equivalent to ask Kong to not run the load-balancing
 phase for this request, and consider it manually overridden.
 Load-balancing components such as retries and health-checks will also be
 ignored for this request.

 The `host` argument expects the hostname or IP address of the upstream
 server, and the `port` expects a port number.


**Phases**

* access

**Parameters**

* **host** (`string`):
* **port** (`number`):

**Usage**

``` lua
kong.service.set_target("service.local", 443)
kong.service.set_target("192.168.130.1", 80)
```



## kong.service.set_tls_cert_key(chain, key)

Sets the client certificate used while handshaking with the Service.

 The `chain` argument is the client certificate and intermediate chain (if any)
 returned by functions such as [ngx.ssl.parse\_pem\_cert](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ssl.md#parse_pem_cert).

 The `key` argument is the private key corresponding to the client certificate
 returned by functions such as [ngx.ssl.parse\_pem\_priv\_key](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ssl.md#parse_pem_priv_key).


**Phases**

{% if_version lte:3.2.x %}
* `rewrite`, `access`, `balancer`
{% endif_version %}

{% if_version gte:3.3.x %}
* `rewrite`, `access`, `balancer`, `preread`
{% endif_version %}

**Parameters**

* **chain** (`cdata`):  The client certificate chain
* **key** (`cdata`):  The client certificate private key

**Returns**

1.  `boolean|nil`:  `true` if the operation succeeded, `nil` if an error occurred

1.  `string|nil`:  An error message describing the error if there was one


**Usage**

``` lua
local chain = assert(ssl.parse_pem_cert(cert_data))
local key = assert(ssl.parse_pem_priv_key(key_data))

local ok, err = kong.service.set_tls_cert_key(chain, key)
if not ok then
  -- do something with error
end
```



## kong.service.set_tls_verify(on)

Sets whether TLS verification is enabled while handshaking with the Service.

 The `on` argument is a boolean flag, where `true` means upstream verification
 is enabled and `false` disables it.

 This call affects only the current request. If the trusted certificate store is
 not set already (via [proxy_ssl_trusted_certificate](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_trusted_certificate)
 or [kong.service.set_upstream_ssl_trusted_store](#kongserviceset_upstream_ssl_trusted_store)),
 then TLS verification will always fail with "unable to get local issuer certificate" error.


**Phases**

{% if_version lte:3.3.x %}
* `rewrite`, `access`, `balancer`
{% endif_version %}

{% if_version gte:3.4.x %}
* `rewrite`, `access`, `balancer`, `preread`
{% endif_version %}

**Parameters**

* **on** (`boolean`):  Whether to enable TLS certificate verification for the current request

**Returns**

1.  `boolean|nil`:  `true` if the operation succeeded, `nil` if an error occurred

1.  `string|nil`:  An error message describing the error if there was one


**Usage**

``` lua
local ok, err = kong.service.set_tls_verify(true)
if not ok then
  -- do something with error
end
```



## kong.service.set_tls_verify_depth(depth)

Sets the maximum depth of verification when validating upstream server's TLS certificate.

 This call affects only the current request. For the depth to be actually used the verification
 has to be enabled with either the [proxy_ssl_verify](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_verify)
 directive or using the [kong.service.set_tls_verify](#kongserviceset_tls_verify) function.


**Phases**

{% if_version lte:3.2.x %}
* `rewrite`, `access`, `balancer`
{% endif_version %}

{% if_version gte:3.3.x %}
* `rewrite`, `access`, `balancer`, `preread`
{% endif_version %}

**Parameters**

* **depth** (`number`):  Depth to use when validating. Must be non-negative

**Returns**

1.  `boolean|nil`:  `true` if the operation succeeded, `nil` if an error occurred

1.  `string|nil`:  An error message describing the error if there was one


**Usage**

``` lua
local ok, err = kong.service.set_tls_verify_depth(3)
if not ok then
  -- do something with error
end
```



## kong.service.set_tls_verify_store(store)

Sets the CA trust store to use when validating upstream server's TLS certificate.

 This call affects only the current request. For the store to be actually used the verification
 has to be enabled with either the [proxy_ssl_verify](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_verify)
 directive or using the [kong.service.set_tls_verify](#kongserviceset_tls_verify) function.

 The resty.openssl.x509.store object can be created by following
 [examples](https://github.com/Kong/lua-kong-nginx-module#restykongtlsset_upstream_ssl_trusted_store) from the Kong/lua-kong-nginx-module repo.


**Phases**

{% if_version lte:3.2.x %}
* `rewrite`, `access`, `balancer`
{% endif_version %}

{% if_version gte:3.3.x %}
* `rewrite`, `access`, `balancer`, `preread`
{% endif_version %}

**Parameters**

* **store** (`table`):  resty.openssl.x509.store object to use

**Returns**

1.  `boolean|nil`:  `true` if the operation succeeded, `nil` if an error occurred

1.  `string|nil`:  An error message describing the error if there was one


**Usage**

``` lua
local store = require("resty.openssl.x509.store")
local st = assert(store.new())
-- st:add(...certificate)

local ok, err = kong.service.set_tls_verify_store(st)
if not ok then
  -- do something with error
end
```