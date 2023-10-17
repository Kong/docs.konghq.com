---
title: Kong Gateway Operator Changelog
no_version: true
---

Changelog for supported {{ site.kgo_product_name }} versions.

## 1.0.1

**Release Date** 2023/10/02

### Fixes

* Fix flapping of `Gateway` managed `ControlPlane` `spec` field when applied without `controlPlaneOptions` set.

### Changes

* Bump `ControlPlane` default version to `v2.12`.
* Bump `WebhookCertificateConfigBaseImage` to `v1.3.0`.

## 1.0.0

**Release Date** 2023/09/27

### Features

* Deploy and configure {{ site.base_gateway }} services
* Customise deployments using `PodTemplateSpec` to deploy sidecars, set node affinity and more.
* Upgrade Data Planes using a rolling restart or blue/green deployments
