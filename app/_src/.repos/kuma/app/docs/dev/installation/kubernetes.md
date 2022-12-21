---
title: Kubernetes
---

To install and run {{site.mesh_product_name}} execute the following steps:

* [1. Download {{site.mesh_product_name}}](#download-kumactl)
* [2. Run {{site.mesh_product_name}}](#run-kuma)
* [3. Use {{site.mesh_product_name}}](#use-kuma)

Finally, you can follow the [Quickstart](#quickstart) to take it from here and continue your {{site.mesh_product_name}} journey.

{% tip %}
{{site.mesh_product_name}} also provides [Helm charts](/docs/{{ page.version }}/installation/helm) that we can use instead of this distribution.
{% endtip %}

### Download Kumactl

{% include snippets/install_kumactl.md %}

### Run {{site.mesh_product_name}}

Finally, we can install and run {{site.mesh_product_name}}:

```sh
kumactl install control-plane | kubectl apply -f -
```

This example will run {{site.mesh_product_name}} in `standalone` mode for a "flat" deployment, but there are more advanced [deployment modes](/docs/{{ page.version }}/introduction/deployments) like "multi-zone".

{% tip %}
It may take a while for Kubernetes to start the {{site.mesh_product_name}} resources, you can check the status by executing:

```sh
kubectl get pod -n {{site.default_namespace}}
```
{% endtip %}

### Use {{site.mesh_product_name}}

{% include snippets/use_kuma_k8s.md %}

### Quickstart

Congratulations! You have successfully installed {{site.mesh_product_name}} on Kubernetes 🚀.

In order to start using {{site.mesh_product_name}}, it's time to check out the [quickstart guide for Kubernetes](/docs/{{ page.version }}/quickstart/kubernetes) deployments.
