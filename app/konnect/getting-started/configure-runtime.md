---
title: Configure a Runtime
no_search: true
no_version: true
---

Set up your first runtime through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/runtime-manager).

At the moment, the only runtime type available is a {{site.ee_gateway_name}}
data plane.

{{site.ee_gateway_name}} data planes proxy service traffic. With
{{site.konnect_short_name}} SaaS working as the control plane, a
runtime doesn't need a database to store configuration data. Instead,
configuration is stored in-memory on each node, and you can easily update
multiple runtimes from one {{site.konnect_short_name}} account with a few clicks.

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

    This scripts creates a Docker container running a simple
    {{site.ee_gateway_name}} instance and connects it to your
    {{site.konnect_short_name}} SaaS account.

    Once the script is done running, the Runtime Manager overview will include
    a new entry, and the tag in the **Node Status** column should say
    **Connected**.

## Summary and Next Steps

In this step, you ran a script which set up a Docker container with a
{{site.ee_gateway_name}} instance, adding your first runtime to the Runtime
Manager.

Next, [set up a your first service package through {{site.konnect_short_name}} SaaS](/konnect/getting-started/configure-service).
