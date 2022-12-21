---
title: Deployments
---

The deployment modes that Kuma provides are quite unique in the Service Mesh landscape and have been developed thanks to the guidance of our enterprise users, especially when it comes to the distributed one.

There are two deployment models that can be adopted with Kuma in order to address any Service Mesh use-case, from the simple one running in one zone to the more complex one where multiple Kubernetes or VM zones are involved, or even hybrid universal ones where Kuma runs simultaneously on Kubernetes and VMs.

The two deployments modes are:

* [**Standalone**](/docs/{{ page.version }}/deployments/stand-alone): Kuma's default deployment model with one control plane (that can be scaled horizontally) and many data planes connecting directly to it.
* [**Multi-Zone**](/docs/{{ page.version }}/deployments/multi-zone): Kuma's advanced deployment model to support multiple Kubernetes or VM-based zones, or hybrid Service Meshes running on both Kubernetes and VMs combined.

{% tip %}
**Automatic Connectivity**: Connectivity for a service mesh should be as automatic as possible, so that when a service consumes another service the only required information is the name of the destination service. Kuma provides connectivity with built-in service discovery. For multi-zone deployments, Zone CPs and a Zone Ingress resource are also provided.
{% endtip %}
