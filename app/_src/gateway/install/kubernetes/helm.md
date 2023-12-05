---
title: Install on Kubernetes with Helm
---

This page explains how to install {{ site.base_gateway }} in traditional mode with a database on Kubernetes.

{:.important}
> **This deployment method should only be used if advised by a member of the Kong team.**
>
> * If you are running on-prem, Kong recommends a [DB-less {{ site.kic_product_name }} installation](/kubernetes-ingress-controller/latest/install/helm/).
> * If you require features such as analytics and a Developer Portal, you should use [Kong Konnect](https://cloud.konghq.com)

## Prerequisites

### Dependencies

- [`Helm 3`](https://helm.sh/)
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/) v1.19 or later

### Helm Charts

Kong provide a Helm chart to deploy {{ site.base_gateway }}. Add the `charts.konghq.com` repository and run `helm repo update` to ensure that you have the latest version of the chart.

```bash
helm repo add kong https://charts.konghq.com
helm repo update
```

## Install Kong

...