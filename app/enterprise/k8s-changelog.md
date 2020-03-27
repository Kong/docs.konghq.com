---
title: Kong Enterprise k8s Changelog
---

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

### Plugins

Follow new enterprise-only plugins have been added in this release:

* degraphql
* graphql-rate-limiting-advanced
* graphql-proxy-cache-advanced

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

* oauth2-introspection
* openid-connect
* proxy-cache-advanced
* rate-limiting-advanced
* response-transformer-advanced
* kafka-log
* kafka-upstream
* canary release
* ldap-auth-advanced
* forward-proxy
* jwt-signer
* collector
* mtls-auth
* request-validator
