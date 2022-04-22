---
title: Kong Cloud
toc: true
---

## Kong Cloud Overview
Kong Cloud is our managed Kong Enterprise offering, based on the proven Kong Enterprise Gateway (Kong API Gateway). Kong Inc. handles all infrastructure concerns such as updates, scaling, data persistence, secure subnet configuration, high availability, and disaster recovery. [Start a free trial](https://konghq.com/products/kong-enterprise/free-trial) today and end your operational worries.

## Kong Cloud differences from on-premise
Despite simply being a managed deployment of Kong Enterprise, Kong Cloud has a few key differences from a customer-hosted Kong Enterprise deployment.

### Security
By default, RBAC is enabled on both Kong Manager and the Kong Enterprise Admin API to prevent unauthorized access to your Kong Enterprise cluster.

A root account named **kong_admin** is created and provisioned on sign up.

### Kong Manager
In Kong Manager, some parts of the interface are hidden or disabled since they aren’t relevant for a hosted setting due to being irrelevant, ephemeral, or inaccessible from outside of the private network. These hidden parts include details about the license, database, and cluster node.

Certain plugins and plugin fields are also disabled. See the plugins section below.

### Plugins
Not all plugins bundled with Kong Enterprise are available in Kong Cloud.

#### Logging Plugins
Customers can request access to Kong Cloud's own Log API, which contains all logs necessary for customers to ingest and analyze. The following plugins would be redundant, and as a result, they are unavailable:

* prometheus
* datadog
* file-log
* http-log
* kafka-log
* loggly
* statsd
* statsd-advanced
* syslog
* tcp-log
* udp-log

#### Serverless Plugins
The following plugins allow executing arbitrary code on the Kong Enterprise Gateway (Kong API Gateway) and are disabled to ensure a secure hosted environment:

* pre-function
* post-function

#### Other Plugins
There are other plugins not categorized above, which are unavailable for the reasons specified:

* request-size-limiting - Disabled for potential memory exhaustion.
* rate-limiting - Only the open-source version is unavailable. Rate Limiting Advanced is available for use in its place.
* kubernetes-sidecar-injector - Kong Cloud does not run in a Kubernetes environment.
* zipkin

#### Third-party / Custom Plugins
Third-party and custom plugins are currently not supported on Kong Cloud. Any plugin deployed on Kong Cloud must first be thoroughly vetted for scalability and security before being allowed to run in the hosted environment.

### Vitals
Kong Cloud only displays vital metrics for the 5-minute timeframe.

Per-node statistics are disabled, only cluster-level metrics are available.

## Kong Cloud IP Addresses for Firewall Configuration
All traffic from Kong Cloud originates from the following list of providers' IP addresses:

### AWS
**us-west-1**
* 54.177.235.50/32
* 13.57.90.100/32

**us-east-1**
* 18.204.28.183/32
* 54.209.226.208/32
