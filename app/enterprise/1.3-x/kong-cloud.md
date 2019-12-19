---
title: Kong Cloud
toc: true
---

# Kong Cloud Overview
Kong Cloud is our managed Kong Enterprise offering, based on the proven Kong Enterprise Gateway (Kong API Gateway). Fully automated, forget about scaling, data persistence, high availability configurations, and failure recovery. [Start a free trial](https://konghq.com/products/kong-enterprise/free-trial) today and end your operational worries.

# Kong Cloud  differences from on-premise
Kong Cloud, while being our hosted Kong Enterprise solution, has a few key differences from a self-hosted, on-premise Kong Enterprise cluster.

## Security
By default, RBAC is enabled on both the Kong Manager and Kong Gateway Admin API to prevent unauthorized access to your Kong Enterprise cluster.

A root account named **kong_admin** will be created and provisioned on sign up.

## Kong Manager
In Kong Manager, some parts of the interface that aren’t relevant for a hosted setting due to being either irrelevant, ephemeral or inaccessible from outside of the private network are hidden or disabled. These include license details, database details, and cluster node details.

Certain plugins and plugin fields are also disabled. See plugins section below.

## Plugins
Not all plugins bundled with Kong Enterprise are available in Kong Cloud. 

### List of Unavailable Plugins on Kong Cloud

#### Logging Plugins
Since Kong Cloud has its own Log API that customers can request access to which contains all logs necessary for customers to ingest and analyze the following plugins are unavailable:

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

* pre_function
* post_function

#### Other Plugins
Plugins not categorized above which have been made unavailable for various reasons:

* request-size-limiting - Disabled for a potential memory exhaustion.
* rate-limiting - Open source version only. Rate limiting advanced is available for use in its place.
* kubernetes-sidecar-injector - Kong Cloud does not run in a Kubernetes environment.
zipkin

#### Third-party / Custom Plugins
Third-party and custom plugins are currently not supported on Kong Cloud. Any plugin deployed on Kong Cloud must first be thoroughly vetted for scalability, and security before being allowed to run in the hosted environment.

## Vitals
Kong Cloud only displays vital metrics for the 5 minute timeframe.

Per-node statistics are disabled, only cluster-level metrics are available.

# Kong Cloud IP Addresses for Firewall Configuration
All traffic from Kong Cloud originates from the following list of providers IP addresses.

## AWS
#### us-west-1
* 54.177.235.50/32
* 13.57.90.100/32

#### us-east-1
* 18.204.28.183/32
* 54.209.226.208/32
