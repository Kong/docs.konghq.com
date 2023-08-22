---
title: Using Kong for Kubernetes
toc: false
---

For information about using Kong for Kubernetes, see the documentation listed below that is available on Github at https://github.com/Kong/kubernetes-ingress-controller/tree/main/docs.


**Topics include:**
- [Concepts](#concepts)
- [Guides and Tutorials](#guides-and-tutorials)
- [Configuration Reference](#configuration-reference)
- [FAQs](#faqs)
- [Troubleshooting](#troubleshooting)
- [Contribute to the Community](#contribute-to-the-community)


### Concepts
Kong for Kubernetes concepts include:
- [Architecture](#architecture)
- [Custom Resources](#custom-resources)
- [Deployment Methods](#deployment-methods)
- [High-availability and Scaling](#high-availability-and-scaling)
- [Security](#security)

#### Architecture
The [design](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/concepts/design.md) document explains how Kong Ingress Controller works inside a Kubernetes cluster and configures Kong to proxy traffic as per rules defined in the Ingress resources.

#### Custom Resources
The Ingress resource in Kubernetes is a fairly narrow and ambiguous API, and does not offer resources to describe the specifics of proxying. To overcome this limitation, the KongIngress Custom resource is used as an "extension" to the existing Ingress API.

A few custom resources are bundled with Kong Ingress Controller to configure settings that are specific to Kong and provide fine-grained control over the proxying behavior.

See [custom resources](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/concepts/custom-resources.md) concept document for more details.

#### Deployment Methods
Kong Ingress Controller can be deployed in a variety of deployment patterns. See the [deployment](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/concepts/deployment.md) documentation, which explains all of the components involved and different ways of deploying them based on the use-case.

#### High-availability and Scaling
The Kong Ingress Controller is designed to scale with your traffic and infrastructure. See [High-availability and Scaling](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/concepts/ha-and-scaling.md) to understand failure scenarios, recovery methods, as well as scaling considerations.

#### Security
See the [Security](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/concepts/security.md) document to understand the default security settings and how to further secure the Ingress Controller.



### Guides and Tutorials
Browse through [guides](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/guides) to get started or understand how to configure a specific setting with Kong Ingress Controller.

### Configuration Reference

The configurations in the Kong Ingress Controller can be customized using Custom Resources and annotations. See the following documents detailing this process:

- [Custom Resource Definitions](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/references/custom-resources.md)
- [Annotations](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/references/annotations.md)
- [CLI arguments](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/references/cli-arguments.md)



### FAQs
[FAQs](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/faq.md) are available to help find answers to quickly resolve common problems. Feel free to open Pull Requests to contribute to the list.



### Troubleshooting
See the [deployment guide](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/deployment) for a detailed understanding of how Kong Ingress Controller is designed and deployed along alongside Kong.

Other resources include:
- [FAQs](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/faq.md)
- The [Troubleshooting guide](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/troubleshooting.md) can help resolve some issues.


### Contribute to the Community
For a place to discuss and share Kong knowledge with the community, visit [Kong Nation](https://discuss.konghq.com/c/kubernetes).
