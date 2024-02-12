---
nav_title: Overview
---

Restrict access to a service or a route by adding consumers to allowed or
denied lists using arbitrary ACL groups. This plugin requires an [authentication plugin](/hub/#authentication)
(such as [Basic Authentication](/hub/kong-inc/basic-auth/), [Key Authentication](/hub/kong-inc/key-auth/),
[OAuth 2.0](/hub/kong-inc/oauth2/) or [OpenID Connect](/hub/kong-inc/openid-connect/)) to have been already
enabled on the service or route.


You can't configure an ACL with both `allow` and `deny` configurations. An ACL with an `allow` provides a positive security model, in which the configured groups are allowed access to the resources, and all others are inherently rejected. By contrast, a `deny` configuration provides a negative security model, in which certain groups are explicitly denied access to the resource (and all others are allowed).

## Get started with the ACL plugin

* [Configuration reference](/hub/kong-inc/acl/configuration/)
* [Basic configuration example](/hub/kong-inc/acl/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/acl/how-to/)
* [ACME plugin API reference](/hub/kong-inc/acl/api/)
