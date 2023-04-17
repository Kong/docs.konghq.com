---
title: Configure a Global Control Plane with Kong Mesh
content_type: tutorial
---

Using Mesh Manager, you can create a {{site.mesh_product_name}} global control plane to manage your {{site.konnect_saas}} services. 

[IMAGE OF GLOBAL CONTROL PLANE MESH THING]

For the purposes of this guide, you'll use {{site.mesh_product_name}} as your service mesh to create a global control plane to manage the service you created previously in the [Configure a Service](/konnect/getting-started/configure-service/) section of the Get Started in {{site.konnect_saas}} documentation.

## Prerequisites <!-- Optional -->

Tutorial topics typically don't contain any prerequisites because you should be helping the user install those things in the steps. The only prerequisites you should include are those for external tools, like jq or Docker, for example. 

In the rare circumstance that you need prerequisites, write them as a bulleted list.

* Docker installed
* jq installed

## Task section <!-- Header optional if there's only one task section in the article -->

A tutorial section title directs the user to perform an action and generally starts with a verb. For example, "Install the software" or "Configure basic settings".

Each task section should include an introduction paragraph that explains what step the user doing, a brief explanation of the feature, and why the user is completing this step.

### Instructions

Steps in each section should break down the tasks the user will complete in sequential order.

Continuing the previous example of installing software, here's an example:

1. Download {{site.mesh_product_name}}:
    ```sh
    curl -L https://docs.konghq.com/mesh/installer.sh | VERSION=2.2.0 sh -
    ```
    Ensure that `VERSION` is replaced with the latest version of {{site.mesh_product_name}}. 
1. ? Konnect steps?
1. Hook back into Mesh

### Explanation of instructions <!-- Optional, but recommended -->

This section should contain a brief, 2-3 sentence paragraph that summarizes what the user accomplished in these steps and what the outcome was. For example, "The software is now installed on your computer. You can't use it yet because the settings haven't been configured. In the next section, you will configure the basic settings so you can start using the software." 

{:.note}
> **Note**: You can also use notes to highlight important information. Try to keep them short.

## Second task section <!-- Optional -->

Adding additional sections can be helpful if you have to switch from working in one product to another or if you switch from one task, like installing to configuring. 

### Instructions

1. First step.
1. Second step.

### Explanation of instructions <!-- Optional, but recommended -->

## See also <!-- Optional, but recommended -->

This section should include a list of tutorials or other pages that a user can visit to extend their learning from this tutorial.

See the following examples of tutorial documentation:
* [Get started with services and routes](https://docs.konghq.com/gateway/latest/get-started/services-and-routes/)
* [Migrate from OSS to Enterprise](https://docs.konghq.com/gateway/latest/migrate-ce-to-ke/)
* [Set up Vitals with InfluxDB](https://docs.konghq.com/gateway/latest/kong-enterprise/analytics/influx-strategy/)