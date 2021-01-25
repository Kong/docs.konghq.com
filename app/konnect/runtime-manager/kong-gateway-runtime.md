---
title: Setting up a Kong Gateway Runtime
no_search: true
no_version: true
---
Set up a [runtime](/konnect/overview/#konnect-key-concepts-and-terminology)
through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/runtime-manager) and
configure your {{site.ee_gateway_name}} instance to accept configuration from
{{site.konnect_short_name}}.

As a quick setup option, run a script to provision a {{site.ee_gateway_name}}
instance in a Docker container, with all connection details configured and
certificates automatically applied.

<div class="alert alert-ee blue">
<b>Note:</b> Kong does not host runtimes. You must host your own runtime
instances.
</div>

## Prerequisites

You have a {{site.konnect_product_name}} account. Contact your sales
representative for access.

## Set up a New Runtime Instance

<div class="alert alert-ee warning">
This process is not yet available in {{site.konnect_short_name}}.
</div>

1. From the left navigation menu, open **Runtimes**.

    This page lists all runtimes that are currently associated with the
    {{site.konnect_short_name}} SaaS account.

2. Click **Configure Runtime**.

3. Click **Copy Script**.

    You can expand the codeblock by clicking **Show** to see the entire script.

4. Replace the placeholder `<your-username>` and `<your-password>` entries with
your {{site.konnect_short_name}} SaaS login credentials.

5. Run the script on any host you choose.

    This script creates a Docker container running a simple
    {{site.ee_gateway_name}} instance and connects it to your
    {{site.konnect_short_name}} SaaS account.

    Once the script is done running, the Runtime Manager overview will include
    a new entry, and the tag in the **Node Status** column should say
    **Connected**.
