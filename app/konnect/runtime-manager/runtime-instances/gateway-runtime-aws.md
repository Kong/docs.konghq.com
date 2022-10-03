---
title: Set up a Kong Gateway Runtime with AWS
no_version: true
content_type: how-to
---

Set up a AWS runtime instance through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/runtime-manager) and
configure your instance to accept configuration from
{{site.konnect_short_name}}. The Runtime Manager keeps track of all runtime
instances associated with the {{site.konnect_saas}} account.

When you create an AWS runtime instance, runtime manager provides a pre-populated template for the runtime instance in AWS.

{:.note}
> **Note:** Kong does not host runtimes. You must install and host your own
runtime instances.

## Quick setup

### Prerequisites

You need an account with AWS that is already configured. <!-- Does this need certain permissions or certain settings configured? -->

IAM resources????

### Configure the AWS Gateway instance

1. Open the {% konnect_icon runtimes %} **Runtime Manager**.

1. Select a runtime group.

1. Click **+ New Runtime Instance**.

1. Click **AWS**.

1. From **AWS Region**, select the region where you want to host the runtime instance.

<!-- Or can we do just a "configure the fields on the page" ?-->

1. Click **Deploy to AWS**. 
This redirects you to the AWS Management Console where it prepopulates a CloudFormation template. 
