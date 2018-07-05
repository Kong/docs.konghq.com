---
title: kong.ip
pdk: true
---

# kong.ip

Trusted IPs module

 This module can be used to determine whether or not a given IP address is
 in the range of trusted IP addresses defined by the `trusted_ips` configuration
 property.

 Trusted IP addresses are those that are known to send correct replacement
 addresses for clients (as per the chosen header field, e.g. X-Forwarded-*).

 See [docs.konghq.com/latest/configuration/#trusted_ips](https://docs.konghq.com/latest/configuration/#trusted_ips)


## Table of Contents

* [kong.ip.is_trusted(address)](#kong_ip_is_trusted)




### <a name="kong_ip_is_trusted"></a>kong.ip.is_trusted(address)

Depending on the `trusted_ips` configuration property,
 this function will return whether a given ip is trusted or not  Both ipv4 and ipv6 are supported.


**Phases**

* init_worker, certificate, rewrite, access, header_filter, body_filter, log

**Parameters**

* **address** (string):  A string representing an IP address

**Returns**

* `boolean` `true` if the IP is trusted, `false` otherwise


**Usage**

``` lua
if kong.ip.is_trusted("1.1.1.1") then
  kong.log("The IP is trusted")
end
```

[Back to TOC](#table-of-contents)

