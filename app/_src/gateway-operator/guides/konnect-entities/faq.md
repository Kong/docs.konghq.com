---
title: FAQ
---

Managing {{ site.konnect_product_name }} entities with {{ site.kgo_product_name }} is a feature that is under active development. This document addresses commonly asked questions.

## I'm a {{ site.kic_product_name }} user, how much will I have to learn?

{{ site.kgo_product_name }} uses the same custom resources as {{ site.kic_product_name }}. A `KongConsumer` is the same no matter which product you're using.

By default, all `Kong*` custom resources will be reconciled by {{ site.kic_product_name }}. To make {{ site.kgo_product_name }} reconcile them with {{ site.konnect_short_name }}, you must provide a `spec.controlPlaneRef.type` of `konnectNamespacedRef`.

## Can I use HTTPRoute and Ingress definitions?

For the first release, we have chosen to keep a 1:1 mapping between custom resources and Konnect entities. This means that you should create `KongService` and `KongRoute` resources rather than `HTTPRoute` or `Ingress` resources.

Support for standard Kubernetes resources is planned for the future.

## How often does the reconcile loop run?

New resources are created immediately using the Konnect API.

Existing resources are processed once per minute by default. This is customizable, but we recommend keeping the default value so that you do not hit the {{ site.konnect_short_name }} API rate limit.

For more information, see [how it works](/gateway-operator/unreleased/guides/konnect-entities/architecture/#how-it-works).

## I deleted a resource in the UI, but it wasn't recreated by the operator. Why?

Wait 60 seconds, then check the UI again. The reconcile loop only runs once per minute.

## Can I use Secrets for consumer credentials like in {{ site.kic_product_name }}?

{{ site.kgo_product_name }} uses new `Credential` CRDs for managing [consumer credentials]((/gateway-operator/unreleased/guides/konnect-entities/consumer-and-consumergroup/#associate-the-consumer-with-credentials)). We plan to support Kubernetes `Secret` resources in a future release. [#618](https://github.com/Kong/gateway-operator/issues/618).

## Can I adopt existing {{ site.konnect_short_name }} entities?

Adopting existing entities is planned, but not yet available. Only resources created by the operator can be managed using CRDs at this time. [#460](https://github.com/Kong/gateway-operator/issues/460)

## How do I create a global plugin?

It is not yet possible to create a global plugin. This is due to {{ site.konnect_short_name }} resources being namespaced in {{ site.kgo_product_name }}, while global plugins are cluster scoped. We are investigating options in [#440](https://github.com/Kong/gateway-operator/issues/440)