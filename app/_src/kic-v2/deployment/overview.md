---
title: Installing and Configuring
---

## Getting started

If you are getting started with Kong for Kubernetes,
install it on Minikube using our Minikube [setup guide](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/minikube/).

Once you've installed the {{site.kic_product_name}}, please follow our
[getting started](/kubernetes-ingress-controller/{{page.kong_version}}/guides/getting-started) tutorial to learn
about how to use the Ingress Controller.

## Overview

The {{site.kic_product_name}} can be installed on a local, managed
or any Kubernetes cluster which supports a service of type `LoadBalancer`.

As explained in the [deployment document](/kubernetes-ingress-controller/{{page.kong_version}}/concepts/deployment/), there
are a variety of configurations and runtimes for the {{site.kic_product_name}}.

Since version 2.4, {{site.kic_product_name}} includes support for the new
Gateway APIs standard by default, but Kubernetes itself does not. You must
[install the Gateway API resources](https://gateway-api.sigs.k8s.io/guides/#installing-gateway-api)
and restart any {{site.kic_product_name}} instances after to use this feature.

{:.important}
> Although the [admission webhook](#admission-webhook) is not enabled by
> all deployment methods, it is strongly recommended for any production
> cluster.

The following sections detail on deployment steps for all the different
runtimes:

## Kong for Kubernetes


Kong for Kubernetes is an Ingress Controller based on the
Open-Source {{site.base_gateway}}. It consists of two components:

- **Kong**: the Open-Source Gateway
- **Controller**: a daemon process that integrates with the
  Kubernetes platform and configures Kong.

Please follow [this guide](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/k4k8s/) to deploy Kong for Kubernetes
using an installation method of your choice.

## Kong for Kubernetes Enterprise

Kong for Kubernetes Enterprise is an enhanced version of
the Open-Source Ingress Controller. It includes all
Enterprise plugins and comes with 24x7 support for worry-free
production deployment.
This is available to enterprise customers of Kong, Inc. only.

Please follow [this guide](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/k4k8s-enterprise/) to deploy Kong for Kubernetes
Enterprise if you have purchased or are trying out {{site.ee_product_name}}.

## Kong for Kubernetes with {{site.ee_product_name}}

Kong for Kubernetes can integrate with {{site.ee_product_name}} to
provide a single pane of visibility across all of your services
that are running in Kubernetes and non-Kubernetes environments.

This [guide](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/kong-enterprise/) goes into details of
the architecture and how one can set that up.

## Admission Webhook

{{site.kic_product_name}} offers an admission webhook. This webhook
validates updates to KongConsumer, credential Secret, and Kong(Cluster)Plugin
resources. When the webhook is enabled, kubectl will display an error
indicating why the configuration is invalid.

To enable the admission webhook, follow the [admission webhook guide](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/admission-webhook/).
