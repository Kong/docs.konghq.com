---
title: Kong Ingress Controller for Kubernetes Association
content_type: explanation
---

You can use native Kubernetes resources to configure your clusters in {{site.konnect_short_name}} by associating your Kong Ingress Controller (KIC) for Kubernetes deployment with {{site.konnect_short_name}}. 
This setup is ideal for organizations who want to manage gateways in {{site.konnect_short_name}} through native Kubernetes resources without having to use a hybrid deployment model. 


## About KIC in {{site.konnect_short_name}}

Kong Ingress Controller (KIC) for Kubernetes configures {{site.base_gateway}} using Ingress or [Gateway API](https://gateway-api.sigs.k8s.io/) resources created inside a Kubernetes cluster. 

Beyond proxying the traffic coming into a Kubernetes cluster, KIC also lets you configure plugins, load balancing, health checking, and leverage all that {{site.base_gateway}} offers in a standalone installation. KIC runtime instances are compatible with all the plugins in the same subscription tier (Free, Plus, and Enterprise) as regular runtime instances. For more information, see [Plugin compatiblity](/konnect/compatibility/#plugin-compatibility). For more information about KIC, see [Kong Ingress Controller Design](/kubernetes-ingress-controller/latest/concepts/design/). 

By associating your KIC deployment with {{site.konnect_short_name}}, this read-only association allows you to view your runtime entities, such as routes and applications, from your Kubernetes resources in {{site.konnect_short_name}}.  

Here are a few benefits of running KIC in {{site.konnect_short_name}} over a self-managed setup:
* **Easy to set up:** The wizard allows you to add your KIC runtime group to {{site.konnect_short_name}} in minutes.
* **Centralized API management:** KIC in {{site.konnect_short_name}} allows organizations to have a centralized platform for API management, regardless of your individual teams' choice of API management, whether that is using Kubernetes or {{site.konnect_short_name}}. 
* **Monitor your KIC analytics:** By associating with {{site.konnect_short_name}}, you can [view the analytics](/konnect/analytics/) from your KIC runtime instances alongside any of your self-managed {{site.konnect_short_name}} runtime instances. 
* **Display KIC entities in Dev Portal:** Publish your KIC services to the Dev Portal and make the API specs available to third-party developers with [API Products](/konnect/api-products/).

## KIC in {{site.konnect_short_name}} association

To associate your KIC runtime instances with {{site.konnect_short_name}}, use the setup wizard to add your KIC deployment to a KIC runtime group.  

In {{site.konnect_short_name}}, navigate to {% konnect_icon runtimes %} **[Runtime Manager](https://cloud.konghq.com/runtime-manager)**, then click **New Runtime Group** > **Kong Ingress Controller**.

{:.note}
> **Note**: KIC OSS and {{site.base_gateway}} Free users can connect to {{site.konnect_short_name}}’s Free tier, while {{site.base_gateway}} Enterprise users can connect to {{site.konnect_short_name}}’s Enterprise tier. To migrate from {{site.ce_product_name}} to {{site.base_gateway}} Enterprise, see [Using Kong Enterprise](/kubernetes-ingress-controller/latest/guides/choose-gateway-image/) in the Kong Ingress Controller documentation.

### Prerequisites

If you don't have an existing KIC deployment, you need the following before using the instructions in the wizard:
*  A Kubernetes cluster with a load balancer
* `kubectl` or `oc` (if you're working with OpenShift) installed and configured to communicate with your Kubernetes TLS
* [Helm 3](https://helm.sh/docs/intro/install/) installed
* Because {{site.kic_product_name}} calls {{site.konnect_short_name}}'s APIs, outbound traffic from {{site.kic_product_name}}'s pods must be allowed to reach {{site.konnect_short_name}}'s `*.konghq.com` [hosts](/konnect/network#hostnames).

### View KIC entities

After your KIC deployment is connected to {{site.konnect_short_name}}, you can view the details for each runtime instance in your KIC runtime groups. 

{:.note}
> **Note**: The KIC deployment in {{site.konnect_short_name}} is currently read-only. The configuration of the gateway runtime is controlled by changes to resources in the Kubernetes API, and reflected here. For more information about how to manage these resources in KIC, see [Custom Resources](/kubernetes-ingress-controller/latest/concepts/custom-resources/).

![KIC runtime instance dashboard](/assets/images/docs/konnect/konnect-runtime-instance-kic.png)
> **Figure 1:** This image shows a KIC runtime instance dashboard. For each KIC runtime instance, you can see details about the runtime instance, analytics, and KIC status details.

Item | Description
------|------------
**KIC Details** | This section displays the status of your KIC runtime instance. The different status options are: Fully Operational, Partially Operational, Not Operational, Unknown, and Disconnected. See the UI for troubleshooting steps related to these statuses. 
**Summary** | This section displays the traffic and error rate of your KIC runtime instance.  
**Analytics** | Analytics data for the KIC runtime instance. You can configure the analytics options using the [**Analytics tool**](/konnect/analytics/). 

## KIC analytics compatibility

The following table describes which {{site.base_gateway}} versions are compatible with the KIC analytics feature in {{site.konnect_short_name}}:

| {{site.base_gateway}} version  | KIC version | Analytics supported | 
|--------------------------------|:---------------------:|---------------
| {{site.ee_product_name}} 3.0.x or later | KIC 2.10 or later | <i class="fa fa-check"></i>
| {{site.base_gateway}} Free 3.0.x or later | KIC 2.10 or later | <i class="fa fa-check"></i>
| {{site.ce_product_name}} | KIC 2.10 or later | <i class="fa fa-times"></i>

## More information

* [Kong Ingress Controller Deployment](/kubernetes-ingress-controller/latest/concepts/deployment/):
    Learn about the various deployment methods for KIC. 
* [Getting started with the Kong Ingress Controller](/kubernetes-ingress-controller/latest/guides/getting-started/):
    This guide walks through setting up an HTTP(S) route and plugin using {{site.base_gateway}} and KIC.
* [Analyze Services and Routes](/konnect/analytics/)
    Learn how to use monitoring tools in Konnect to analyze KIC entities.
* [Publish and Consume Services](/konnect/getting-started/publish-service/):
    Find out how to publish services to the Dev Portal.
