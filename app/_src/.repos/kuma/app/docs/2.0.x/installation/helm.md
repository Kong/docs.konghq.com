---
title: Helm
---

To install and run {{site.mesh_product_name}} on Kubernetes with Helm charts execute the following steps:

* [1. Add the {{site.mesh_product_name}} charts repository](#add-the-kuma-charts-repository)
* [2. Run {{site.mesh_product_name}}](#run-kuma)
* [3. Use {{site.mesh_product_name}}](#use-kuma)

Finally you can follow the [Quickstart](#quickstart) to take it from here and continue your {{site.mesh_product_name}} journey.

Please note that at least version 3.8.0 of Helm is required to use the {{site.mesh_product_name}} Helm charts. If you are using an older version of Helm, please upgrade to version 3.8.0 first.

{% tip %}
{{site.mesh_product_name}} also provides an alternative [Kubernetes distribution](/docs/{{ page.version }}/installation/kubernetes/) that we can use instead of Helm charts.
{% endtip %}

### Add the {{site.mesh_product_name}} charts repository

To start using {{site.mesh_product_name}} with Helm charts, we first need to add the [{{site.mesh_product_name}} charts repository](https://kumahq.github.io/charts) to our local Helm deployment: 

```sh
helm repo add kuma https://kumahq.github.io/charts
```

Once the repo is added, all following updates can be fetched with `helm repo update`.

### Run {{site.mesh_product_name}}

At this point we can install and run {{site.mesh_product_name}} using the following commands. We could use any Kubernetes namespace to install {{site.mesh_product_name}}, by default we suggest using `{{site.default_namespace}}`:

```sh
helm install --create-namespace --namespace {{site.default_namespace}} kuma kuma/kuma
```

This example will run {{site.mesh_product_name}} in `standalone` mode for a "flat" deployment, but there are more advanced [deployment modes](/docs/{{ page.version }}/introduction/deployments) like "multi-zone".

### Use {{site.mesh_product_name}}

{% include snippets/use_kuma_k8s.md %}

### Quickstart

Congratulations! You have successfully installed {{site.mesh_product_name}} on Kubernetes 🚀. 

In order to start using {{site.mesh_product_name}}, it's time to check out the [quickstart guide for Kubernetes](/docs/{{ page.version }}/quickstart/kubernetes/) deployments.

## Argo CD

{{site.mesh_product_name}} requires a certificate to verify a connection between the control plane and a data plane proxy.
{{site.mesh_product_name}} Helm chart autogenerate self-signed certificate if the certificate isn't explicitly set.
Argo CD uses `helm template` to compare and apply Kubernetes YAMLs.
Helm template doesn't work with chart logic to verify if the certificate is present.
This results in replacing the certificate on each Argo redeployment.
The solution to this problem is to explicitly set the certificates.
See ["Data plane proxy to control plane communication"](/docs/{{ page.version }}/security/certificates#data-plane-proxy-to-control-plane-communication) to learn how to preconfigure {{site.mesh_product_name}} with certificates.
