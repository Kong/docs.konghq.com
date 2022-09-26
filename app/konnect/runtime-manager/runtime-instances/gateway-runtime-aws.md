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

You have the following options when configuring a new runtime instance with AWS:
* Use the quick setup script, which generates a data plane container
running on `localhost`.
* Use the advanced setup to customize your installation.

{:.note}
> **Note:** Kong does not host runtimes. You must install and host your own
runtime instances.

## Quick setup

### Prerequisites

You need an account with AWS that is already configured. <!-- Does this need certain permissions or certain settings configured? -->

IAM resources????

### Run the quick setup script

1. Open the {% konnect_icon runtimes %} **Runtime Manager**.

1. Select a runtime group.

1. Click **+ New Runtime Instance**.

1. Click **AWS**.

1. From **AWS Region**, select the region where you want to host the runtime instance.

<!-- Or can we do just a "configure the fields on the page" ?-->

1. Click **Deploy to AWS**. 
This redirects you to the AWS Management Console.

1. On the **Specify stack details** page, type a stack name in the **Stack name** box. This name should be unique across your AWS subscription, as in the name should be unique across all gateway instance deployments in your AWS organization.
