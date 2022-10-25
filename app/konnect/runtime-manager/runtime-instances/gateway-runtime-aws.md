---
title: Set up a Kong Gateway Runtime with AWS
content_type: how-to
alpha: true
---

Set up a AWS runtime instance through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/runtime-manager) and
configure your instance to accept configuration from
{{site.konnect_short_name}}. The Runtime Manager keeps track of all runtime
instances associated with the {{site.konnect_saas}} account.

Runtime Manager provides a pre-populated template for a runtime instance in AWS. This template creates the following resources in AWS:
* Amazon VPC along with internet gateway 
* Secret
* Amazon EC2 instances (key pair, role, profile)
* Auto Scaling group
* Network Load Balancer
* Optional: CloudWatch log group 
* Optional: Redis 


## Prerequisites

* An account with AWS that is already configured
* An account that can use IAM resources

## Configure the AWS Gateway instance

1. Open the {% konnect_icon runtimes %} **Runtime Manager**.

1. Select a runtime group.

1. Click **New Runtime Instance**.

1. Click **AWS**.

1. From **AWS Region**, select the region where you want to host the runtime instance.

1. Configure the fields on the page:

    | Field | Description |
    |---|---|
    | AWS Region | The AWS region where the CloudFormation template should be created. |
    | Instance type for the gateway runtime instances | A valid x86_64 EC2 instance type. You can edit this later in AWS. |
    | Create an ElastiCache Cluster | This is used for rate limiting plugins. Selecting **Yes** creates an ElastiCache cluster. |
    | Enable Cloud Watch Logs collection | Sets up CloudWatch logs for the {{site.konnect_short_name}} access and error logs. Selecting **Yes** enables log collection. |
    | Existing VPC ID (Optional) | Enter an existing VPC ID, or leave blank to generate a new VPC ID. |
    | Existing Subnet IDs (Optional) | Enter an existing subnet ID, or leave blank to generate a new subnet ID. |

1. Click **Deploy to AWS**. 
This redirects you to the AWS Management Console where it pre-populates a CloudFormation template. If the cluster certificate and key are not populated in the AWS template, copy the values in {{site.konnect_short_name}}.

## Verify the AWS runtime instance configuration

1. In AWS CloudFormation on the **Outputs** tab, verify that the NetworkLoadBalancer DNS displays. 

1. In {{site.konnect_short_name}}, open the {% konnect_icon runtimes %} **Runtime Manager** and select a runtime group. A new runtime instance should display with information about connection, when it was last seen, and the status.
