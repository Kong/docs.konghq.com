---
title: Kong Ingress Controller
type: explanation
purpose: |
  Provide an overview of KIC and what it's used for
---

{{ site.kic_product_name }} allows you to run {{ site.base_gateway }} as a Kubernetes Ingress to handle inbound requests for a Kubernetes cluster.

{{ site.kic_product_name }} takes Kubernetes resources such as `Ingress` and `HTTPRoute` and converts them into a valid {{ site.base_gateway }} configuration. It enables you to use all the [features](/gateway/latest/#features) of {{ site.base_gateway }}.

## Architecture

A Kubernetes ingress controller is an application that runs in a cluster and configures a load balancer based on Kubernetes resources (`Ingress`, `HTTPRoute`, `TCPRoute` and more). {{ site.kic_product_name }} configures {{ site.base_gateway }} as a software load balancer which runs in the cluster and is typically exposed as a `LoadBalancer` service.

[Learn More &raquo;](/kubernetes-ingress-controller/{{ page.release }}/concepts/architecture/)

![KIC and {{ site.base_gateway }} Architecture Diagram](/assets/images/products/kubernetes-ingress-controller/kic-gateway-arch.png)


## Deployment Methods

Kong recommends using the `kong/ingress` Helm chart to deploy {{ site.kic_product_name }}. This chart supports both [DB-less](/kubernetes-ingress-controller/{{ page.release }}/production/deployment-topologies/gateway-discovery/) and [DB-backed](/kubernetes-ingress-controller/{{ page.release }}/production/deployment-topologies/db-backed/) deployments. If you're not sure which to choose, we recommend choosing DB-less which treats the Kubernetes API server as the source of truth.

[Learn More &raquo;](/kubernetes-ingress-controller/{{ page.release }}/production/deployment-topologies/gateway-discovery/)

## Common Use Cases

Many {{ site.kic_product_name }} users have the same questions when adding an ingress controller to their cluster:

* How do I expose my service on a specific path?
* How do I protect the service with rate limiting?
* How do I cache responses for a period of time to reduce load?
* How do I add authentication to my service?

To do all of these in under 10 minutes, follow our [getting started guide](/kubernetes-ingress-controller/{{ page.release }}/get-started/) which takes you through step-by-step. Each page contains copy/paste instructions and links to further information if you want to learn more.

## Gateway API Support

Kong are proud to be a driving force behind the Kubernetes Gateway API standard. With multiple contributors in maintainer and reviewer roles, Kong is all-in on Gateway API as the future of Kubernetes networking.

{{ site.kic_product_name }} was the first submitted conformance report, and is 100% compliant with the core conformance tests (in addition to many extended tests). Kong has implemented the Gateway API resources as first-class citizens, converting them directly in to {{ site.base_gateway }} configuration rather than using intermediate CRDs. This makes the Gateway API CRDs a native language for {{ site.kic_product_name }}.

[Learn More &raquo;](/kubernetes-ingress-controller/{{ page.release }}/gateway-api/)

## Troubleshooting

The following pages may help if {{ site.kic_product_name }} is not working for you:

* [Troubleshooting](/kubernetes-ingress-controller/{{ page.release }}/reference/troubleshooting/): Common issues that people encounter when running {{ site.kic_product_name }}.
* [FAQ](/kubernetes-ingress-controller/{{ page.release }}/reference/faq/router/): Specific questions about routing behavior, plugin compatibility and more.
* [Feature Gates](/kubernetes-ingress-controller/{{ page.release }}/reference/feature-gates/): If something isn't working as expected, ensure that you have the correct feature gates enabled
* [Create a GitHub issue](https://github.com/Kong/kubernetes-ingress-controller/issues/new/choose): Report a bug or make a feature request for {{ site.kic_product_name }}.
* [Join the Kong Slack community](https://konghq.com/community#64fe8580b1a2f3c3804230f1): Get help from the team