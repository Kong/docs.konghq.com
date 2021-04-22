---
title: Securing the Admin API
---

## Introduction

Kong's Admin API provides a RESTful interface for administration and
configuration of Services, Routes, Plugins, Consumers, and Credentials. Because this
API allows full control of Kong, it is important to secure this API against
unwanted access. This document describes a few possible approaches to securing
the Admin API.

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

[Back to top](#introduction)

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

[Back to top](#introduction)

## Kong API Loopback

Kong's routing design allows it to serve as a proxy for the Admin API itself. In
this manner, Kong itself can be used to provide fine-grained access control to
the Admin API. Such an environment requires bootstrapping a new Service that defines
the `admin_listen` address as the Service's `url`.

For example, let's assume that Kong `admin_listen` is `127.0.0.1:8001`, so it is only
available from localhost. The port `8000` is serving proxy traffic, presumably exposed via
`myhost.dev:8000`

We want to expose Admin API via the url `:8000/admin-api`, in a controlled way. We can do so by
creating a Service and Route for it from inside `127.0.0.1`:

```bash
$ curl -X POST http://127.0.0.1:8001/services \
  --data name=admin-api \
  --data host=127.0.0.1 \
  --data port=8001

$ curl -X POST http://127.0.0.1:8001/services/admin-api/routes \
  --data paths[]=/admin-api
```

We can now transparently reach the Admin API through the proxy server, from outside `127.0.0.1`:

```bash
$ curl myhost.dev:8000/admin-api/services
{
   "data":[
      {
        "id": "653b21bd-4d81-4573-ba00-177cc0108dec",
        "created_at": 1422386534,
        "updated_at": 1422386534,
        "name": "admin-api",
        "retries": 5,
        "protocol": "http",
        "host": "127.0.0.1",
        "port": 8001,
        "path": "/admin-api",
        "connect_timeout": 60000,
        "write_timeout": 60000,
        "read_timeout": 60000
      }
   ],
   "total":1
}
```

From here, simply apply desired Kong-specific security controls (such as
[basic][basic-auth] or [key authentication][key-auth],
[IP restrictions][ip-restriction], or [access control lists][acl]) as you would
normally to any other Kong API.

If you are using Docker to host {{site.ee_product_name}}, you can accomplish a similar task using a declarative configuration such as this one:

``` yaml
_format_version: "1.1"

services:
- name: admin-api
  url: http://127.0.0.1:8001
  routes:
    - paths:
      - /admin-api
  plugins:
  - name: key-auth

consumers:
- username: admin
  keyauth_credentials:
  - key: secret
```

Under this configuration, the Admin API will be available through the `/admin-api`, but only for requests accompanied with `?apikey=secret` query
parameters.

Assuming that the file above is stored in `$(pwd)/kong.yml`, a DB-less {{site.ee_product_name}} can use it as it starts like this:

``` bash
$ docker run -d --name kong-ee \
    -e "KONG_DATABASE=off" \
    -e "KONG_DECLARATIVE_CONFIG=/home/kong/kong.yml"
    -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
    -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
    -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
    -v $(pwd):/home/kong
    kong-ee
```

With a PostgreSQL database, the initialization steps would be the following:

``` bash
# Start PostgreSQL on a Docker container
# Notice that PG_PASSWORD needs to be set
$ docker run --name kong-ee-database \
    -p 5432:5432 \
    -e "POSTGRES_USER=kong" \
    -e "POSTGRES_DB=kong" \
    -e "POSTGRES_PASSWORD=$PG_PASSWORD" \
    -d postgres:9.6

# Run Kong migrations to initialize the database
$ docker run --rm \
    --link kong-ee-database:kong-ee-database \
    -e "KONG_DATABASE=postgres" \
    -e "KONG_PG_HOST=kong-ee-database" \
    -e "KONG_PG_PASSWORD=$PG_PASSWORD" \
    kong-ee kong migrations bootstrap

# Load the configuration file which enables the Admin API loopback
# Notice that it is assumed that kong.yml is located in $(pwd)/kong.yml
$ docker run --rm \
    --link kong-ee-database:kong-ee-database \
    -e "KONG_DATABASE=postgres" \
    -e "KONG_PG_HOST=kong-ee-database" \
    -e "KONG_PG_PASSWORD=$PG_PASSWORD" \
    -v $(pwd):/home/kong \
    kong-ee kong config db_import /home/kong/kong.yml

# Start Kong
$ docker run -d --name kong \
    --link kong-ee-database:kong-ee-database \
    -e "KONG_DATABASE=postgres" \
    -e "KONG_PG_HOST=kong-ee-database" \
    -e "KONG_PG_PASSWORD=$PG_PASSWORD" \
    -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
    -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
    -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
    kong-ee
```

In both cases, once Kong is up and running, the Admin API would be available but protected:

``` bash
$ curl myhost.dev:8000/admin-api/services
=> HTTP/1.1 401 Unauthorized

$ curl myhost.dev:8000/admin-api/services?apikey=secret"
=> HTTP/1.1 200 OK
{
    "data": [
        {
            "ca_certificates": null,
            "client_certificate": null,
            "connect_timeout": 60000,
        ...
```

[Back to top](#introduction)

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

[Back to top](#introduction)

## Role Based Access Control ##

<div class="alert alert-warning">
  <strong>{{site.konnect_short_name}}-Only</strong> This feature is only available with an
  {{site.konnect_product_name}} subscription.
</div>

Enterprise users can configure role-based access control to secure access to the
Admin API. RBAC allows for fine-grained control over resource access based on
a model of user roles and permissions. Users are assigned to one or more roles,
which each in turn possess one or more permissions granting or denying access
to a particular resource. In this way, fine-grained control over specific Admin
API resources can be enforced, while scaling to allow complex, case-specific
uses.

If you are not a Kong Enterprise customer, you can inquire about our
Enterprise offering by [contacting us](/enterprise).

[Back to top](#introduction)


[acl]: /hub/kong-inc/acl
[basic-auth]: /hub/kong-inc/basic-authentication/
[custom-configuration]: /enterprise/{{page.kong_version}}/property-reference/#custom-nginx-configuration
[ip-restriction]: /hub/kong-inc/ip-restriction
[key-auth]: /hub/kong-inc/key-authentication
