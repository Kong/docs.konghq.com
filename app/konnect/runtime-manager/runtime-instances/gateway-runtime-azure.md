---
title: Set up a Kong Gateway Runtime with Azure
content_type: how-to
alpha: true
---

Set up a Azure runtime instance through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/runtime-manager) and
configure your instance to accept configuration from
{{site.konnect_short_name}}. The Runtime Manager keeps track of all runtime
instances associated with the {{site.konnect_saas}} account.

Runtime Manager provides a pre-populated template for a runtime instance in Azure.


## Prerequisites

You need an account with Azure that is already configured.

## Configure the Azure Gateway instance

1. Open the {% konnect_icon runtimes %} **Runtime Manager**.

1. Select a runtime group.

1. Click **New Runtime Instance**.

1. Click **Azure**.

1. Click **Deploy to Azure**. This redirects you to Azure.

1. In Azure, enter the cluster control plane, cluster telemetry endpoint, cluster certificate, and cluster certificate key values from {{site.konnect_short_name}} into the Azure template.