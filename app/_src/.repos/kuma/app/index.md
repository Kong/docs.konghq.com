---
layout: home 
permalink: /

search: false

themeContainerClasses: 'no-sidebar is-home'

# page meta
meta:
  - name: keywords
    content: service mesh microservices open-source

# custom page data
showTestimonial: true # change this to `true` if you want to display the testimonial
showNews: true # change this to `true` if you want to display the news bar
whyText: Explore Policies
whyUrl: /policies/

# testimonials
testimonials:
  - content: "We chose Kuma in large part because we needed a solution that would allow our customers to support both Kubernetes and virtual machines, while providing an easier path to migrating between the two."
    author: "Aaron Weikle"
    title: "CEO of MS3"
    image: "/assets/images/ms3-logo.png"
    alt: "Logo for MS3"

# carousel
carousel:
  - alt: Screenshot of the Kuma GUI with charts
    src: /assets/images/kuma_gui.png
  - alt: Screenshot of the Kuma Graphana Metrics
    src: /assets/images/kuma_metrics.png
  - alt: Screenshot of the Kuma Observability
    src: /assets/images/kuma_observability.png
---

{% contentfor news %}

**Kuma 2.0.0 has been released!** &mdash; eBPF support, Next Gen Policies and New UI Improvements, and much more [on the Kuma 2.0.0 release blog post](/blog/2022/kuma-2-0-0/)

{% endcontentfor %}

<!-- page masthead -->

{% contentfor masthead-main-title %}

# The universal Envoy service mesh<br> for distributed service connectivity

{% endcontentfor %}

{% contentfor masthead-main-title  %}

## The open-source control plane for service mesh, <br>delivering security, observability, routing and more

{% endcontentfor %}

<!-- feature blocks -->

{% contentfor feature-block-content-1 %}

### Kubernetes, VMs & Multi-Mesh

<img alt="CRD + RESTful Interface diagram" src="/assets/images/diagrams/v3/diagram-crd-rest@2x.png" loading="lazy"/>

Built on top of Envoy, Kuma is a modern control plane for Microservices & Service Mesh for both K8s and VMs, with support for multiple meshes in one cluster.

{% endcontentfor %}

{% contentfor feature-block-content-2 %}

### Easy To Use & Upgrade

<img src="/assets/images/diagrams/v3/diagram-l4-l7-policies@2x.png" loading="lazy" alt="L4 and L7 Policies chart"/>

Out of the box L4 + L7 policy architecture to enable zero trust security, observability, discovery, routing and traffic reliability in one click. Easy, yet powerful.

{% endcontentfor %}

{% contentfor feature-block-content-3 %}

### Multi-Cloud & Multi-Cluster

<img alt="Platform Agnostic diagram" src="/assets/images/diagrams/v3/diagram-platform-agnostic@2x.png" loading="lazy"/>

Built for the enterprise, Kuma ships with the most scalable multi-zone connectivity across multiple clouds & clusters on Kubernetes, VMs or hybrid.

{% endcontentfor %}

<!-- tabs -->

{% contentfor tab-kubernetes %}

[Install Kuma](/install/) via an available distribution:

```sh
kumactl install control-plane \
  | kubectl apply -f-
```

Visualize the GUI to see your cluster:

```sh
kubectl port-forward svc/kuma-control-plane \
  -n kuma-system 5681:5681
```

Navigate to [127.0.0.1:5681/gui](http://127.0.0.1:5681/gui) to see the GUI.

{% endcontentfor %}

{% contentfor tab-openshift %}


[Install Kuma](/install/) via an available distribution:

```sh
kumactl install control-plane \
  --cni-enabled | oc apply -f -
```

Visualize the GUI to see your cluster:

```sh
oc port-forward svc/kuma-control-plane \
  -n kuma-system 5681:5681
```

Navigate to [127.0.0.1:5681/gui](http://127.0.0.1:5681/gui) to see the GUI.

{% endcontentfor %}

{% contentfor tab-universal %}

[Install Kuma](/install/) via an available distribution:

```sh
kuma-cp run
```

Navigate to [127.0.0.1:5681/gui](http://127.0.0.1:5681/gui) to see the GUI.

{% endcontentfor %}

{% contentfor tabs-right-col-content %}

### Start in minutes, not in days

Getting up and running with Kuma only requires three easy steps. Natively embedded with Envoy proxy, Kuma Delivers easy to use policies that can secure, observe, connect, route and enhance service connectivity for every application and services, databases included.

- Bundled with Envoy Proxy. No Envoy expertise required.
- 10+ Policies ready to use for all L4 + L7 traffic in the organization.
- Ships with native CRDs and a GUI + REST API and a CLI too.

{% endcontentfor %}

<!-- content blocks -->

{% contentfor feature-focus-1-content %}

### Single and Multi-Zone Connectivity

Build modern service and application connectivity across every platform, cloud and architecture. Kuma supports modern Kubernetes environments and Virtual Machine workloads in the same cluster, with native multi-cloud and multi-cluster connectivity to support the entire organization.

- Multi-zone deployment for multi-cloud and multi-cluster.
- Kubernetes and VMs support, including hybrid.
- Native Ingress, Gateway and multi-mesh support.

{% endcontentfor %}

{% contentfor feature-focus-1-diagram %}

<img alt="Diagram outlining connectivity with no boundaries" loading="lazy" src="/assets/images/diagrams/v3/diagram-connectivity-new@2x.png"/>

{% endcontentfor %}

{% contentfor feature-focus-2-content %}

### One cluster for the entire organization

Designed for the enterprise architect, Kuma ships with a native multi-mesh support to support multiple teams from one control plane. Combined with native service discovery, global and remote deployments modes, and native integration with APIM solutions, Kuma checks all the boxes.

- Built for the enterprise architect for mission-critical use-cases.
- Multi-Mesh from one control plane to lower Ops complexity.
- Scalable horizontally in standalone or multi-zone mode.

{% endcontentfor %}

{% contentfor feature-focus-2-diagram %}

<img alt="Diagram outlining one cluster for the entire organization" loading="lazy" src="/assets/images/diagrams/v3/diagram-one-cluster-new@2x.png"/>

{% endcontentfor %}

<!-- newsletter -->

{% contentfor newsletter-title %} 

### Ready to get started?

{% endcontentfor %}

{% contentfor newsletter-content %}

Receive a step-by-step onboarding guide delivered directly to your inbox

{% endcontentfor %}
