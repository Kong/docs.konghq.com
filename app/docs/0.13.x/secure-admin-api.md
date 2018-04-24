---
title: Securing the Admin API
---

# Securing the Admin API

Kong's Admin API provides a RESTful interface for administration and
configuration of Services, Routes, Plugins, Consumers, and Credentials. Because this
API allows full control of Kong, it is important to secure this API against
unwanted access. This document describes a few possible approaches to securing
the Admin API.

## Table of Contents

- [Network Layer Access Restrictions](#network-layer-access-restrictions)
  - [Minimal Listening Footprint](#minimal-listening-footprint)
  - [Layer 3/4 Network Controls](#layer-3-4-network-controls)
- [Kong API Loopback](#kong-api-loopback)
- [Custom Nginx Configuration](#custom-nginx-configuration)
- [Role Based Access Control (RBAC)](#role-based-access-control)

## Network Layer Access Restrictions

### Minimal Listening Footprint

By default since its 0.12.0 release, Kong will only accept requests from the
local interface, as specified in its default `admin_listen` value:

```
admin_listen = 127.0.0.1:8001
```

If you change this value, always ensure to keep the listening footprint to a
minimum, in order to avoid exposing your Admin API to third-parties, which
could seriously compromise the security of your Kong cluster as a whole.
For example, **avoid binding Kong to all of your interfaces**, by using
values such as `0.0.0.0:8001`.

[Back to TOC](#table-of-contents)

### Layer 3/4 Network Controls

In cases where the Admin API must be exposed beyond a localhost interface,
network security best practices dictate that network-layer access be restricted
as much as possible. Consider an environment in which Kong listens on a private
network interface, but should only be accessed by a small subset of an IP range.
In such a case, host-based firewalls (e.g. iptables) are useful in limiting
input traffic ranges. For example:


```bash
# assume that Kong is listening on the address defined below, as defined as a
# /24 CIDR block, and only a select few hosts in this range should have access

$ grep admin_listen /etc/kong/kong.conf
admin_listen 10.10.10.3:8001

# explicitly allow TCP packets on port 8001 from the Kong node itself
# this is not necessary if Admin API requests are not sent from the node
$ iptables -A INPUT -s 10.10.10.3 -m tcp -p tcp --dport 8001 -j ACCEPT

# explicitly allow TCP packets on port 8001 from the following addresses
$ iptables -A INPUT -s 10.10.10.4 -m tcp -p tcp --dport 8001 -j ACCEPT
$ iptables -A INPUT -s 10.10.10.5 -m tcp -p tcp --dport 8001 -j ACCEPT

# drop all TCP packets on port 8001 not in the above IP list
$ iptables -A INPUT -m tcp -p tcp --dport 8001 -j DROP

```

Additional controls, such as similar ACLs applied at a network device level, are
encouraged, but fall outside the scope of this document.

[Back to TOC](#table-of-contents)

## Kong API Loopback

Kong's routing design allows it to serve as a proxy for the Admin API itself. In
this manner, Kong itself can be used to provide fine-grained access control to
the Admin API. Such an environment requires bootstrapping a new Service that defines
the `admin_listen` address as the Service's `url`. For example:

```bash
# assume that Kong has defined admin_listen as 127.0.0.1:8001, and we want to
# reach the Admin API via the url `/admin-api`

$ curl -X POST http://localhost:8001/services \
  --data name=admin-api \
  --data host=localhost \
  --data port=8001

$ curl -X POST http://localhost:8001/services/admin-api/routes \
  --data paths[]=/admin-api
  
# we can now transparently reach the Admin API through the proxy server
$ curl localhost:8000/admin-api/apis
{
   "data":[
      {
         "uris":[
            "\/admin-api"
         ],
         "id":"653b21bd-4d81-4573-ba00-177cc0108dec",
         "upstream_read_timeout":60000,
         "preserve_host":false,
         "created_at":1496351805000,
         "upstream_connect_timeout":60000,
         "upstream_url":"http:\/\/localhost:8001",
         "strip_uri":true,
         "https_only":false,
         "name":"admin-api",
         "http_if_terminated":true,
         "upstream_send_timeout":60000,
         "retries":5
      }
   ],
   "total":1
}
```

From here, simply apply desired Kong-specific security controls (such as
[basic][basic-auth] or [key authentication][key-auth],
[IP restrictions][ip-restriction], or [access control lists][acl]) as you would
normally to any other Kong API.

[Back to TOC](#table-of-contents)

## Custom Nginx Configuration

Kong is tightly coupled with Nginx as an HTTP daemon, and can thus be integrated
into environments with custom Nginx configurations. In this manner, use cases
with complex security/access control requirements can use the full power of
Nginx/OpenResty to build server/location blocks to house the Admin API as
necessary. This allows such environments to leverage native Nginx authorization
and authentication mechanisms, ACL modules, etc., in addition to providing the
OpenResty environment on which custom/complex security controls can be built.

For more information on integrating Kong into custom Nginx configurations, see
[Custom Nginx configuration & embedding Kong][custom-configuration].

[Back to TOC](#table-of-contents)

## Role Based Access Control ##

<div class="alert alert-warning">
  <strong>Enterprise-Only</strong> This feature is only available with an
  Enterprise Subscription.
</div>

Enterprise users can configure role-based access control to secure access to the
Admin API. RBAC allows for fine-grained control over resource access based on
a model of user roles and permissions. Users are assigned to one or more roles,
which each in turn possess one or more permissions granting or denying access
to a particular resource. In this way, fine-grained control over specific Admin
API resources can be enforced, while scaling to allow complex, case-specific
uses.

If you are not a Mashape Enterprise customer, you can inquire about our
Enterprise offering by [contacting us](/enterprise).

[Back to TOC](#table-of-contents)


[acl]: /plugins/acl
[basic-auth]: /plugins/basic-authentication/
[custom-configuration]: /docs/{{page.kong_version}}/configuration/#custom-nginx-configuration
[ip-restriction]: /plugins/ip-restriction
[key-auth]: /plugins/key-authentication
