---
title: Kong Ingress Controller for Kubernetes Association
content_type: explanation
beta: true
---

You can use native Kubernetes resources to configure your clusters in {{site.konnect_short_name}} by associating your Kong Ingress Controller (KIC) for Kubernetes deployment with {{site.konnect_short_name}}. 
This setup is ideal for organizations who want to manage gateways in {{site.konnect_short_name}} through native Kubernetes resources without having to use a hybrid deployment model. 

{:.note}
> **Note**: KIC in {{site.konnect_short_name}} is available to existing Enterprise-tier customers, and Kong is extending support to new signups for Free and Plus tiers.

## About KIC in {{site.konnect_short_name}}

Kong Ingress Controller (KIC) for Kubernetes configures {{site.base_gateway}} using Ingress or [Gateway API](https://gateway-api.sigs.k8s.io/) resources created inside a Kubernetes cluster. 

Beyond proxying the traffic coming into a Kubernetes cluster, KIC also lets you configure plugins, load balancing, health checking, and leverage all that {{site.base_gateway}} offers in a standalone installation. For more information about KIC, see [Kong Ingress Controller Design](/kubernetes-ingress-controller/latest/concepts/design/). 

By associating your KIC deployment with {{site.konnect_short_name}}, this read-only association allows you to view your runtime entities, such as routes and applications, from your Kubernetes resources in {{site.konnect_short_name}}.  

Here are a few benefits of running KIC in {{site.konnect_short_name}} over a self-managed setup:
* **Easy to set up:** The wizard allows you to add your KIC runtime group to {{site.konnect_short_name}} in minutes.
* **Centralized API management:** KIC in {{site.konnect_short_name}} allows organizations to have a centralized platform for API management, regardless of your individual teams' choice of API management, whether that is using Kubernetes or {{site.konnect_short_name}}. 


<!-- Add this back in for milestone 2
* **Monitor your KIC analytics:** By associating with {{site.konnect_short_name}}, you can view the analytics from your KIC runtime instances alongside any of your self-managed {{site.konnect_short_name}} runtime instances. 
* **Display KIC entities in Dev Portal:** Publish your KIC services to the Dev Portal and make the API specs available to third-party developers.-->

## KIC in {{site.konnect_short_name}} association

To associate your KIC runtime instances with {{site.konnect_short_name}}, use the setup wizard to add your KIC deployment to a KIC runtime group.  

In {{site.konnect_short_name}}, navigate to {% konnect_icon runtimes %} **[Runtime Manager](https://cloud.konghq.com/runtime-manager)**, then click **New Runtime Group** > **Kubernetes Ingress Controller**.

{:.note}
> **Note**: KIC OSS users can connect to {{site.konnect_short_name}}’s Free tier, while KIC Enterprise users can connect to {{site.konnect_short_name}}’s Enterprise tier.

### Prerequisites

If you don't have an existing KIC deployment, you need the following before using the instructions in the wizard:
*  A Kubernetes cluster 
* `kubectl` or `oc` (if you're working with OpenShift) installed and configured to communicate with your Kubernetes TLS
* [Helm 3](https://helm.sh/docs/intro/install/) installed

### View KIC entities

After your KIC deployment is connected to {{site.konnect_short_name}}, you can view the details for each runtime instance in your KIC runtime groups. 

![KIC runtime instance dashboard](/assets/images/docs/konnect/konnect-runtime-instance-kic.png)
> **Figure 1:** This image shows a KIC runtime instance dashboard. For each KIC runtime instance, you can see details about the runtime instance, analytics, and KIC status details.

{:.note}
> **Note**: The KIC deployment in {{site.konnect_short_name}} is currently read-only. The configuration of the gateway runtime is controlled by changes to resources in the Kubernetes API, and reflected here. For more information about how to manage these resources in KIC, see [Custom Resources](/kubernetes-ingress-controller/latest/concepts/custom-resources/). 

## More information

* [Kong Ingress Controller Deployment](/kubernetes-ingress-controller/latest/concepts/deployment/)
    Learn about the various deployment methods for KIC. 
* [Getting started with the Kong Ingress Controller](/kubernetes-ingress-controller/latest/guides/getting-started/)
    This guide walks through setting up an HTTP(S) route and plugin using {{site.base_gateway}} and KIC.
* [Analyze Services and Routes](/konnect/analytics/services-and-routes/)
    Learn how to use monitoring tools in Konnect to analyze KIC entities.
* [Publish and Consume Services](/konnect/getting-started/publish-service/)
    Find out how to publish services to the Dev Portal.
