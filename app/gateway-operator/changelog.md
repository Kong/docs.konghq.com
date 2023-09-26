---
title: Kong Gateway Operator Changelog
no_version: true
---

Changelog for supported {{ site.kgo_product_name }} versions. 

## 1.0.0
**Release Date** 2023/09/27

### Features 

* Deploy and configure {{ site.base_gateway }} services
* Customise deployments using `PodTemplateSpec` to deploy sidecars, set node affinity and more.
* Upgrade Data Planes using a rolling restart or blue/green deployments