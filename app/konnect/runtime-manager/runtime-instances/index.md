---
title: About Runtime Instances
content_type: explanation
disable_image_expand: true
---

A runtime instance is a single self-managed instance of {{site.base_gateway}} that functions as a data plane. In {{site.konnect_saas}}, runtime instances are part of [runtime groups](/konnect/runtime-manager/runtime-groups) and can be used to serve traffic to the runtime group. Runtime groups manage and store configuration in {{site.konnect_saas}}, and runtime instances are configured according to the configuration distributed by the runtime group. 

{{site.konnect_short_name}} provides runtime instance installation scripts for various platforms. These runtime instances are configured to run in your {{site.konnect_short_name}} environment.
You can access these scripts from the {{site.konnect_short_name}} **Runtime Manager**. 

## Supported installation options

{:.note}
> **Note:** Kong does not host runtime instances. You must install and host your own.

{% include install.html config=site.data.tables.install_options_konnect header='no-header' %}

## Communicating through a forward proxy 

In situations where forward proxies are non-transparent, you can still connect the {{site.base_gateway}} data plane with the {{site.konnect_saas}} control plane. 
To do this, you need to configure each {{site.base_gateway}} runtime instance to authenticate with the proxy server and allow traffic through.
For more information, see [Control Plane and Data Plane Communication through a Forward Proxy](/gateway/latest/production/networking/cp-dp-proxy/) in the {{site.base_gateway}} documentation.

## Running on AWS

Runtime Manager provides a pre-populated template for a runtime instance in AWS. 
If you install runtime instances on AWS, the template creates the following resources in AWS:
* Amazon VPC along with internet gateway 
* Secret
* Amazon EC2 instances (key pair, role, profile)
* Auto Scaling group
* Network Load Balancer
* Optional: CloudWatch log group 
* Optional: Redis 

## More information

- [Upgrade a runtime instance](/konnect/runtime-manager/runtime-instances/upgrade/)
- [Renew certificates](/konnect/runtime-manager/runtime-instances/renew-certificates/)
- [Backup and restore](/konnect/runtime-manager/backup-restore/)
- [Forward proxy connections](/gateway/latest/production/networking/cp-dp-proxy/)
- [Runtime parameter reference](/konnect/runtime-manager/runtime-instances/runtime-parameter-reference/)
- [Analytics dashboard](/konnect/analytics/)