---
title: Upgrades
---

Upgrades can be performed up to two major versions. Examples:
* You can upgrade from `1.5.x` to `1.6.x`
* You can upgrade from `1.4.x` to `1.6.x`
* To upgrade from `1.2.x` to `1.6.x`, first upgrade from `1.2.x` to `1.4.x`. Then from `1.4.x` to `1.6.x`.

{% tip %}
To avoid control plane downtime when restarting on the new version make sure you have more than one instance of the control plane in each zone.
{% endtip %}

## Standalone

To upgrade Kuma with standalone deployment, first upgrade the control plane, then upgrade data plane proxies.
To upgrade data plane proxies on Kubernetes, rollout the new deployment. This way injector will inject the newest sidecar.

`kuma-dp` follows the same compatibility rules with `kuma-cp`. Examples:
* You can connect `kuma-dp` `1.4.x` to `kuma-cp` `1.6.x`
* You cannot connect `kuma-dp` `1.3.x` to `kuma-cp` `1.6.x`. It may cause undefined behavior.

## Multizone

To upgrade Kuma with multizone deployment, first upgrade the global control plane. Then, upgrade zone control planes.
As a last step, upgrade data plane proxies.

Global control plane follows the same compatibility rules with zone control planes. Examples:
* You can connect zone control plane `1.4.x` to global control plane `1.6.x`.
* You cannot connect zone control plane `1.3.x` to global control plane `1.6.x`. It may cause undefined behavior.
