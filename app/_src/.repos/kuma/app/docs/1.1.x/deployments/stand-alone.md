---
title: Set up a standalone deployment
---

This is the simplest deployment mode for Kuma, and the default one.

* **Control plane**: There is one deployment of the control plane that can be scaled horizontally.
* **Data plane proxies**: The data plane proxies connect to the control plane regardless of where they are deployed.
* **Service Connectivity**: Every data plane proxy must be able to connect to every other data plane proxy regardless of where they are being deployed.

This mode implies that we can deploy Kuma and its data plane proxies in a standalone networking topology mode so that the service connectivity from every data plane proxy can be established directly to every other data plane proxy.

<center>
<img src="/assets/images/docs/0.6.0/flat-diagram.png" alt="" style="width: 500px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

Although standalone mode can support complex multi-zone or hybrid deployments (Kubernetes + VMs) as long as the networking requirements are satisfied, typically in most use cases our connectivity cannot be flattened out across multiple zones. Therefore standalone mode is usually a great choice within the context of one zone (ie: within one Kubernetes cluster or one AWS VPC).

### Usage

In order to deploy Kuma in a standalone deployment, the `kuma-cp` control plane must be started in `standalone` mode:

{% tabs usage useUrlFragment=false %}
{% tab usage Kubernetes %}
This is the standard installation method as described in the [installation page](/install).
```sh
kumactl install control-plane | kubectl apply -f -
```
{% endtab %}
{% tab usage Universal %}
This is the standard installation method as described in the [installation page](/install).
```sh
kuma-cp run
```
{% endtab %}
{% endtabs %}

Once Kuma is up and running, data plane proxies can now [connect](/docs/{{ page.version }}/documentation/dps-and-data-model) directly to it. 

{% tip %}
When the mode is not specified, Kuma will always start in `standalone` mode by default.
{% endtip %}

