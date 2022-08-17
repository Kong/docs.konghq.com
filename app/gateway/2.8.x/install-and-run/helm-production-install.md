---
title: How to set up a Kong Gateway production environment
---
The final guide is a production deployment guide with individual Helm releases per component
This page explains how to install {{site.base_gateway}} with {{site.kic_product_name}} using Helm.

* The Enterprise deployment includes a Postgres sub-chart provided by Bitnami.
* For open-source deployments, you can choose to use the Postgres sub-chart, or install without a database.

Configuration for both options is flexible and depends on your environment.

The documentation on installing with a [flat Kubernetes manifest](/gateway/{{page.kong_version}}/install-and-run/kubernetes) also explains how to install in DB-less mode for both Enterprise and OSS deployments.

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).
{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

- A Kubernetes cluster, v1.19 or later
- `kubectl` v1.19 or later
- (Enterprise only) A `license.json` file from Kong
- Helm 3

## Steps Go here

Create the namespace for {{site.base_gateway}} with {{site.kic_product_name}}. For example:

```sh
kubectl create namespace kong
```


See the [Kong Ingress Controller docs](/kubernetes-ingress-controller/) for  how-to guides, reference guides, and more.
