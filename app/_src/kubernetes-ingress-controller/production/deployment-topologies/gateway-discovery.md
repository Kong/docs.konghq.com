---
title: Gateway Discovery
type: explanation
purpose: |
  What is Gateway Discovery?
---

Gateway Discovery is a deployment topology in which {{ site.kic_product_name }} and {{ site.base_gateway }} are separate deployments in the Kubernetes cluster. {{ site.kic_product_name }} uses Kubernetes service discovery to discover the {{ site.base_gateway }} Pods.

It allows you to manage many {{ site.base_gateway }} instances with one {{ site.kic_product_name }}, providing lower resource usage compared to [sidecar](/kubernetes-ingress-controller/{{ page.release }}/production/deployment-topologies/sidecar/) deployments.

## How It Works

{:.note}
> You don't need to configure this manually due to the default value of `gatewayDiscovery.generateAdminApiService=true` in the Helm chart. The following information is for educational purposes only.

When {{ site.kic_product_name }} starts running it looks for services that match the name in the `--kong-admin-svc` flag. This value is controlled by the `gatewayDiscovery.adminApiService.namespace` and `gatewayDiscovery.adminApiService.name` values in the Helm chart. Once the service is found, {{ site.kic_product_name }} fetches a list of [EndpointSlices](https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/) containing all {{ site.base_gateway }} instances.

{{ site.kic_product_name }} proceeds to send configuration to all detected {{ site.base_gateway }} instances using the `POST /config` endpoint on each running data plane. Once the data plane has loaded configuration, it is marked as ready and can start proxying traffic.

![Gateway Discovery Architecture Diagram](/assets/images/products/kubernetes-ingress-controller/topology/gateway-discovery.png)