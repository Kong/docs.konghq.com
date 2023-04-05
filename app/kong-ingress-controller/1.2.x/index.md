---
title: Kong Ingress Controller
subtitle: An ingress controller for the {{site.base_gateway}}
---

## Concepts

### Architecture

The [design][design] document explains how the {{site.kic_product_name}} works
inside a Kubernetes cluster and configures Kong to proxy traffic as per
rules defined in the Ingress resources.

### Custom Resources

The Ingress resource in Kubernetes is a fairly narrow and ambiguous API, and
doesn't offer resources to describe the specifics of proxying.
To overcome this limitation, the `KongIngress` Custom resource is used as an
"extension" to the existing Ingress API.

A few custom resources are bundled with the {{site.kic_product_name}} to
configure settings that are specific to Kong and provide fine-grained control
over the proxying behavior.

Please refer to [custom resources][crd] concept document for more details.

### Deployment Methods

The {{site.kic_product_name}} can be deployed in a variety of deployment patterns.
Please refer to the [deployment](/kong-ingress-controller/{{page.kong_version}}/concepts/deployment/) documentation,
which explains all the components
involved and different ways of deploying them based on the use-case.

### High-availability and Scaling

The {{site.kic_product_name}} is designed to scale with your traffic
and infrastructure.
Please refer to [this document](/kong-ingress-controller/{{page.kong_version}}/concepts/ha-and-scaling/) to understand
failures scenarios, recovery methods, as well as scaling considerations.

### Ingress classes

[Ingress classes](/kong-ingress-controller/{{page.kong_version}}/concepts/ingress-classes) filter which resources the
controller loads. They ensure that {{site.kic_product_name}} instances do not
load configuration intended for other instances or other ingress controllers.

### Security

Please refer to [this document](/kong-ingress-controller/{{page.kong_version}}/concepts/security/) to understand the
default security settings and how to further secure the Ingress Controller.

## Guides and Tutorials

Please browse through [guides][guides] to get started or understand how to configure
a specific setting with the {{site.kic_product_name}}.

## Configuration Reference

The configurations in the {{site.kic_product_name}} can be tweaked using
Custom Resources and annotations.
Please refer to the following documents detailing this process:

- [Custom Resource Definitions](/kong-ingress-controller/{{page.kong_version}}/references/custom-resources/)
- [Annotations](/kong-ingress-controller/{{page.kong_version}}/references/annotations/)
- [CLI arguments](/kong-ingress-controller/{{page.kong_version}}/references/cli-arguments/)
- [Version compatibility matrix](/kong-ingress-controller/{{page.kong_version}}/references/version-compatibility/)
- [Plugin compatibility matrix](/kong-ingress-controller/{{page.kong_version}}/references/plugin-compatibility/)

## FAQs

[FAQs][faqs] will help find answers to common problems quickly.
Please feel free to open Pull Requests to contribute to the list.

## Troubleshooting

Please read through our [deployment guide][deployment] for a detailed
understanding of how Ingress Controller is designed and deployed
along alongside Kong.

- [FAQs][faqs] might help as well.
- [Troubleshooting][troubleshooting] guide can help
  resolve some issues.  
  Please contribute back if you feel your experience can help
  the larger community.

[annotations]: /kong-ingress-controller/{{page.kong_version}}/references/annotations
[crd]: /kong-ingress-controller/{{page.kong_version}}/concepts/custom-resources
[deployment]: /kong-ingress-controller/{{page.kong_version}}/deployment/overview
[design]: /kong-ingress-controller/{{page.kong_version}}/concepts/design
[faqs]: /kong-ingress-controller/{{page.kong_version}}/faq
[troubleshooting]: /kong-ingress-controller/{{page.kong_version}}/troubleshooting
[guides]: /kong-ingress-controller/{{page.kong_version}}/guides/overview
