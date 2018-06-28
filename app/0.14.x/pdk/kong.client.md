---
title: kong.client
pdk: true
---

# kong.client

Client information module
 A set of functions to retrieve information about the client connecting to
 Kong in the context of a given request.

 See also:
 [nginx.org/en/docs/http/ngx_http_realip_module.html](http://nginx.org/en/docs/http/ngx_http_realip_module.html)

## Table of Contents

* [kong.client.get_ip()](#kong_client_get_ip)
* [kong.client.get_forwarded_ip()](#kong_client_get_forwarded_ip)
* [kong.client.get_port()](#kong_client_get_port)
* [kong.client.get_forwarded_port()](#kong_client_get_forwarded_port)




### <a name="kong_client_get_ip"></a>kong.client.get_ip()

Returns the remote address of the client making the request.  This will
 **always** return the address of the client directly connecting to Kong.
 That is, in cases when a load balancer is in front of Kong, this function
 will return the load balancer's address, and **not** that of the
 downstream client.


**Phases**

* certificate, rewrite, access, header_filter, body_filter, log

**Returns**

* `string` ip The remote address of the client making the request


**Usage**

``` lua
-- Given a client with IP 127.0.0.1 making connection through
-- a load balancer with IP 10.0.0.1 to Kong answering the request for
-- https://example.com:1234/v1/movies
kong.client.get_ip() -- "10.0.0.1"
```

[Back to TOC](#table-of-contents)


### <a name="kong_client_get_forwarded_ip"></a>kong.client.get_forwarded_ip()

Returns the remote address of the client making the request.  Unlike
 `kong.client.get_ip`, this function will consider forwarded addresses in
 cases when a load balancer is in front of Kong. Whether this function
 returns a forwarded address or not depends on several Kong configuration
 parameters:

 * [trusted\_ips](https://getkong.org/docs/latest/configuration/#trusted_ips)
 * [real\_ip\_header](https://getkong.org/docs/latest/configuration/#real_ip_header)
 * [real\_ip\_recursive](https://getkong.org/docs/latest/configuration/#real_ip_recursive)


**Phases**

* certificate, rewrite, access, header_filter, body_filter, log

**Returns**

* `string`  ip The remote address of the client making the request,
 considering forwarded addresses



**Usage**

``` lua
-- Given a client with IP 127.0.0.1 making connection through
-- a load balancer with IP 10.0.0.1 to Kong answering the request for
-- https://username:password@example.com:1234/v1/movies

kong.request.get_forwarded_ip() -- "127.0.0.1"

-- Note: assuming that 10.0.0.1 is one of the trusted IPs, and that
-- the load balancer adds the right headers matching with the configuration
-- of `real_ip_header`, e.g. `proxy_protocol`.
```

[Back to TOC](#table-of-contents)


### <a name="kong_client_get_port"></a>kong.client.get_port()

Returns the remote port of the client making the request.  This will
 **always** return the port of the client directly connecting to Kong. That
 is, in cases when a load balancer is in front of Kong, this function will
 return load balancer's port, and **not** that of the downstream client.

**Phases**

* certificate, rewrite, access, header_filter, body_filter, log

**Returns**

* `number` The remote client port


**Usage**

``` lua
-- [client]:40000 <-> 80:[balancer]:30000 <-> 80:[kong]:20000 <-> 80:[service]
kong.client.get_port() -- 30000
```

[Back to TOC](#table-of-contents)


### <a name="kong_client_get_forwarded_port"></a>kong.client.get_forwarded_port()

Returns the remote port of the client making the request.  Unlike
 `kong.client.get_port`, this function will consider forwarded ports in cases
 when a load balancer is in front of Kong. Whether this function returns a
 forwarded port or not depends on several Kong configuration parameters:

 * [trusted\_ips](https://getkong.org/docs/latest/configuration/#trusted_ips)
 * [real\_ip\_header](https://getkong.org/docs/latest/configuration/#real_ip_header)
 * [real\_ip\_recursive](https://getkong.org/docs/latest/configuration/#real_ip_recursive)

**Phases**

* certificate, rewrite, access, header_filter, body_filter, log

**Returns**

* `number` The remote client port, considering forwarded ports


**Usage**

``` lua
-- [client]:40000 <-> 80:[balancer]:30000 <-> 80:[kong]:20000 <-> 80:[service]
kong.client.get_forwarded_port() -- 40000

-- Note: assuming that [balancer] is one of the trusted IPs, and that
-- the load balancer adds the right headers matching with the configuration
-- of `real_ip_header`, e.g. `proxy_protocol`.
```

[Back to TOC](#table-of-contents)

