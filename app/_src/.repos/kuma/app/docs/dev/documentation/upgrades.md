---
title: Upgrades
---

Since {{site.mesh_product_name}} 1.4.x upgrades can be performed up to two minor versions. Examples:
* You can upgrade from `1.5.x` to `1.6.x`
* You can upgrade from `1.4.x` to `1.6.x`
* To upgrade from `1.2.x` to `1.6.x`, first upgrade from `1.2.x` to `1.4.x`. Then from `1.4.x` to `1.6.x`.

{% tip %}
To avoid control plane downtime when restarting on the new version make sure you have more than one instance of the control plane in each zone.
{% endtip %}

`kuma-dp` follows the above compatibility rules with `kuma-cp`. Examples:
* You can connect `kuma-dp` `1.4.x` to `kuma-cp` `1.6.x`
* You cannot connect `kuma-dp` `1.3.x` to `kuma-cp` `1.6.x`. It may cause undefined behavior.

Global control plane follows the above compatibility rules with zone control planes. Examples:
* You can connect zone control plane `1.4.x` to global control plane `1.6.x`.
* You cannot connect zone control plane `1.3.x` to global control plane `1.6.x`. It may cause undefined behavior.

Despite control-planes within a zone not connecting to each other; they share a common [store](/docs/{{ page.version }}/documentation/configuration#store) (usually Kubernetes or Postgres), compatibility of the storage layer follows the above rules too:
* You can read any data written with a control-plane `1.4.x` with a control-plane version `1.6.x`.
* You can read any data written with a control-plane `1.6.x` with a control-plane version `1.4.x`.
* You cannot read data written with a control-plane `1.3.x` with a control-plane version `1.6.x` or higher. It may cause undefined behavior.
* You cannot read data written with a control-plane `1.6.x` with a control-plane version `1.3.x` or lower. It may cause undefined behavior.


{% warning %}
Some feature flags may not provide backward compatibility, when this is the case it is clearly documented in [the control-plane configuration](/docs/{{ page.version }}/generated/kuma-cp) and will be part of the `experimental` section.

To guarantee our compatibility policy we will always wait at least two minor versions before making these features enabled by default.
{% endwarning %}

## Standalone

To upgrade {{site.mesh_product_name}} with a standalone deployment, first upgrade the control plane, then upgrade data plane proxies.
To upgrade data plane proxies on Kubernetes, rollout the new deployment. This way injector will inject the newest sidecar.

## Multizone

To upgrade {{site.mesh_product_name}} with a multizone deployment, first upgrade the global control plane. Then, upgrade zone control planes.
As a last step, upgrade data plane proxies.
