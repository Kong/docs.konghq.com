---
title: Kong Enterprise k8s Changelog
no_version: true
skip_read_time: true
---

<div class="alert alert-ee">
<strong>Note:</strong> Kong Enterprise k8s is deprecated as of <strong>2020/08/25</strong>.
Existing users of this image who want to use {{site.ee_product_name}} 2.1.x or
later should switch to the <a href="/enterprise/latest/kong-for-kubernetes/deployment-options"><code>kong-enterprise-edition</code></a> image.
<br>
<br>
See the <a href="https://github.com/Kong/kubernetes-ingress-controller/blob/main/CHANGELOG.md">Kong Ingress Controller changelog</a> for all of the most
up-to-date information.
</div>

## 2.0.4.2

> Released on 2020/06/29

### Fixed

- Resolve an incompatibility between LuaRocks and a dependency that prevented
  installing custom plugins in custom images.

## 2.0.4.1

> Released on 2020/05/05

### Fixed

- Ensure that a worker being spawned due to any errors always receives the
  latest up-to-date configuration in the DB-less mode
  [#5850](https://github.com/Kong/kong/pull/5850)

## 2.0.4.0

> Released on 2020/04/28

### Summary

Kong Enterprise k8s 2.0.4.0 is based on Kong Gateway 2.0.4.

### Kong Gateway

Kong Enterprise k8s 2.0.4.0 is based on Kong Gateway 2.0.4,
meaning it inherits the bug-fixes between Kong Gateway 2.0.2 and
2.0.4.
Please review the changelog for
[Kong Gateway](https://github.com/Kong/kong/blob/master/CHANGELOG.md).

### Enterprise Plugins

The following fixes have been included in this release:

- `openid-connect` plugin has been bumped up to v1.4.2
  - Adds support for `client_secret_jwt` and `private_key_jwt` authentication
  - Adds support for cookie for `config.bearer_token_param_type`
  - Adds support for `config.bearer_token_cookie_name`
- `collector` plugin has been bumped up to v1.7.4
- `response-transformer-advanced` has been bumped up to v0.3.3
- `mtls-auth` plugin has been bumped up to v0.1.1
- `kafka-log` plugin has been bumped up to v0.1.0

## 2.0.2.0

> Released on 2020/03/27

### Summary

Kong Enterprise k8s 2.0.2.0 is based on Kong Gateway 2.0.2.

### Kong Gateway

Kong Enterprise k8s 2.0.2.0 is based on Kong Gateway 2.0.2,
meaning it inherits all new features and changes between Kong Gateway 1.4.2 and
2.0.2.
Please review the changelog for
[Kong Gateway](https://github.com/Kong/kong/blob/master/CHANGELOG.md).

### Enterprise Plugins

The following plugins are included in this release:

* degraphql
* graphql-proxy-cache-advanced
* graphql-rate-limiting-advanced

## 1.4.2.0

> Released on 2020/01/02

### Summary

Kong Enterprise k8s 1.4.2.0 is based on Kong Gateway 1.4.2.

### Kong Gateway

Kong Enterprise k8s 1.4.2.0 is based on Kong Gateway 1.4.2,
meaning it inherits all new features and changes between Kong Gateway 1.3.0 and
1.4.2.
Please review the changelog for
[Kong Gateway 1.4.0](https://github.com/Kong/kong/blob/master/CHANGELOG.md#140).

## 1.3.0.0

> Released on 2019/11/19

### Summary

Kong Enterprise k8s 1.3.0.0 is the debut release for this package.

### Kong Gateway

Kong Enterprise k8s 1.3.0.0 is based on Kong Gateway 1.3.0,
meaning it inherits all the features and changes from it.
Please review the changelog for
[Kong Gateway 1.3.0](https://github.com/Kong/kong/blob/master/CHANGELOG.md#130).

### Enterprise plugins

The following plugins are included with this release:

* canary release
* collector
* forward-proxy
* jwt-signer
* kafka-log
* kafka-upstream
* ldap-auth-advanced
* mtls-auth
* oauth2-introspection
* openid-connect
* proxy-cache-advanced
* rate-limiting-advanced
* request-validator
* response-transformer-advanced
* vault-auth
