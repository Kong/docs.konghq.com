---
title: Installing Gateway APIs
content_type: tutorial
---

{% if_version lte: 2.5.x %}
{:.warning .no-icon}
> This feature is released as a [tech preview](/gateway/latest/availability-stages/#tech-preview) (alpha-quality) and should not be deployed in a production environment.
{% endif_version %}
{% if_version gte: 2.6.x %}
{:.warning .no-icon}
> This feature is released as a [beta](/gateway/latest/availability-stages/#beta) and should not be deployed in a production environment.
{% endif_version %}

The [Gateway APIs](https://gateway-api.sigs.k8s.io/) are an upcoming set of
Kubernetes APIs developed by Kubernetes SIG-NETWORK. They expand on and refine
the concepts introduced by the Ingress APIs. In addition to revised HTTP
routing APIs, they provide standardized resources representing gateway
configuration and layer 4 (TCP and UDP) routing configuration.

The Gateway APIs are currently a draft standard and are not available by
default in Kubernetes installations. To use them, you must [install the Gateway
APIs resource definitions and admission controller](https://gateway-api.sigs.k8s.io/guides/#installing-gateway-api).

{% if_version lte: 2.5.x %}
Support for Gateway APIs is disabled by default. After installing the APIs, you
must enable support for them in {{site.kic_product_name}}:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl set env -n kong deployment/ingress-kong CONTROLLER_FEATURE_GATES="Gateway=true" -c ingress-controller
```
{% endnavtab %}
{% navtab Response %}
```text
deployment.apps/ingress-kong env updated
```
{% endnavtab %}
{% endnavtabs %}
{% endif_version %}
{% if_version gte: 2.6.x %}
{{site.kic_product_name}} automatically disables support for non-standard
resources if they are not available at start, so you must restart it after
installing Gateway APIs for it to recognize those resources:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl rollout restart -n NAMESPACE deployment DEPLOYMENT_NAME
```
{% endnavtab %}
{% navtab Response %}
```text
deployment.apps/DEPLOYMENT_NAME restarted
```
{% endnavtab %}
{% endnavtabs %}
{% endif_version %}

## Using alpha APIs

{:.warning .no-icon}
> This feature is released as a [tech preview](/gateway/latest/availability-stages/#tech-preview) (alpha-quality) and should not be deployed in a production environment.

Layer 4 routes (TCPRoute, UDPRoute, TLSRoute) are currently only available in
the Gateway APIs experimental channel. 

These APIs require version 2.6 or higher. To use them on a supported version,
install the experimental channel CRDs and enable the corresponding feature gate
in {{site.kic_product_name}}:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl set env -n kong deployment/ingress-kong CONTROLLER_FEATURE_GATES="GatewayAlpha=true" -c ingress-controller
```
{% endnavtab %}
{% navtab Response %}
```text
deployment.apps/ingress-kong env updated
```
{% endnavtab %}
{% endnavtabs %}

If you also use other feature gates, include them as well. The command above
replaces the entire `CONTROLLER_FEATURE_GATES` value.
