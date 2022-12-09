---
title: Kubernetes
---

To install and run Kuma execute the following steps:

* [1. Download Kuma](#download-kumactl)
* [2. Run Kuma](#run-kuma)
* [3. Use Kuma](#use-kuma)

Finally, you can follow the [Quickstart](#quickstart) to take it from here and continue your Kuma journey.

{% tip %}
Kuma also provides [Helm charts](/docs/{{ page.version }}/installation/helm) that we can use instead of this distribution.
{% endtip %}

### Download Kumactl

{% include snippets/install_kumactl.md %}

### Run Kuma

Finally, we can install and run Kuma:

```sh
kumactl install control-plane | kubectl apply -f -
```

This example will run Kuma in `standalone` mode for a "flat" deployment, but there are more advanced [deployment modes](/docs/{{ page.version }}/introduction/deployments) like "multi-zone".

{% tip %}
It may take a while for Kubernetes to start the Kuma resources, you can check the status by executing:

```sh
kubectl get pod -n kuma-system
```
{% endtip %}

### Use Kuma

{% include snippets/use_kuma_k8s.md %}

### Quickstart

Congratulations! You have successfully installed Kuma on Kubernetes 🚀.

In order to start using Kuma, it's time to check out the [quickstart guide for Kubernetes](/docs/{{ page.version }}/quickstart/kubernetes) deployments.
