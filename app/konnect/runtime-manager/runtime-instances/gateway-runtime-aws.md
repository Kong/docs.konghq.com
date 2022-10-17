---
title: Set up a Kong Gateway Runtime with AWS
no_version: true
content_type: how-to
alpha: true
---

Set up a AWS runtime instance through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/runtime-manager) and
configure your instance to accept configuration from
{{site.konnect_short_name}}. The Runtime Manager keeps track of all runtime
instances associated with the {{site.konnect_saas}} account.

When you create an AWS runtime instance, runtime manager provides a pre-populated template for the runtime instance in AWS. This template creates the following resources in AWS:
* Amazon VPC along with internet gateway 
* Secret
* Amazon EC2 instances (keypair, role, profile)
* Autoscaling group
* Network Load Balancer
* Optional: CloudWatch log group 
* Optional: Redis 

{:.note}
> **Note:** Kong does not host runtimes. You must install and host your own
runtime instances.

## Prerequisites

* An account with AWS that is already configured
* An account that can use IAM resources

## Configure the AWS Gateway instance

1. Open the {% konnect_icon runtimes %} **Runtime Manager**.

1. Select a runtime group.

1. Click **+ New Runtime Instance**.

1. Click **AWS**.

1. From **AWS Region**, select the region where you want to host the runtime instance.

<!-- Or can we do just a "configure the fields on the page" ?-->

1. Click **Deploy to AWS**. 
This redirects you to the AWS Management Console where it prepopulates a CloudFormation template. 

## Verify the AWS runtime instance configuration

1. In AWS CloudFormation on the **Outputs** tab, verify that the NetworkLoadBalancer DNS displays. 

1. In {{site.konnect_short_name}}, open the {% konnect_icon runtimes %} **Runtime Manager** and select a runtime group. A new runtime instance should display with information about connection, when it was last seen, and the status.
