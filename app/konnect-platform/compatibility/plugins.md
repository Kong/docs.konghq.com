---
title: Plugin Compatibility
no_version: true
---

## Introduction

Each [{{site.konnect_product_name}} tier](https://konghq.com/pricing) gives you
access to a subset of plugins:
* **Free tier:** Open-source Kong plugins
* **Plus tier:** Open-source and Plus-specific plugins
* **Enterprise tier:** All Kong plugins

### Network configuration options

{{site.konnect_short_name}} can be configured in the following ways:

* **Kong-hosted cloud**: Hybrid deployment. Nodes are split into control plane and
data plane roles. Kong provides and hosts the control plane and a database with
{{site.konnect_saas}}, and you provide the data plane nodes (no databases required).

* **Self-managed**: Use any hosting service of your choice or host on-premises,
with any of the following network configurations:
    * **Classic:** Every node is connected to a database. Refers to a classic
    deployment on any platform, including Kubernetes.
    * **DB-less:** Deployed without a database (available in {{site.ce_product_name}}
    1.1 and {{site.ee_product_name}} 2.4 onward). Admin API is read-only,
    except for the `/config` endpoint. Refers to a DB-less deployment on any
    platform, including Kubernetes.
    * **Hybrid mode:** Nodes are split into control plane and data plane roles.
    The control plane coordinates configuration and propagates it to data plane
    nodes, so only control plane nodes require a database
    (available in {{site.ce_product_name}} 2.0 and {{site.ee_product_name}} 2.1 onward).

<!-- COMMENTED OUT TEMPORARILY AS WE DON'T HAVE THESE DOCS AT THE MOMENT
For details on the differences between deployment types, see
[Kong Deployment Options]()-->
For the differences between deployment types when running on Kubernetes,
see [{{site.ee_product_name}} for Kubernetes Deployment Options](/gateway/latest/plan-and-deploy/kubernetes-deployment-options/).

## Plugin tiers and supported network configurations
<!-- To add or edit table entries in this topic, see /app/_data/tables/plugin_index.yml in this repo -->

{% assign categories = site.data.tables.plugin_index %}

{% for category in categories %}
<h3 id="{{ category.name | downcase | split: " " | join: "-" }}">
  {{ category.name }}
</h3>

<table>
  <thead>
      <th style="text-align: left; width: 10%">Plugin</th>
      <th style="text-align: center">Free</th>
      <th style="text-align: center">Plus</th>
      <th style="text-align: center">Enterprise</th>
      <th style="width: 20%">Supported network configuration</th>
      <th style="text-align: left; width: 35%">Notes</th>
  </thead>
  <tbody>
    {% for plugin in category.plugins %}
      <tr>
        <td>
          <a href="{{plugin.url}}">{{ plugin.name }}</a>
        </td>
        <td style="text-align: center">
          {% if plugin.free == true %}
          <i class="fa fa-check"></i>
          {% elsif plugin.free == false %}
          <i class="fa fa-times"></i>
          {% endif %}
        </td>
        <td style="text-align: center">
          {% if plugin.plus == true %}
          <i class="fa fa-check"></i>
          {% elsif plugin.plus == false %}
          <i class="fa fa-times"></i>
          {% endif %}
        </td>
        <td style="text-align: center">
          {% if plugin.enterprise == true %}
          <i class="fa fa-check"></i>
          {% elsif plugin.enterprise == false %}
          <i class="fa fa-times"></i>
          {% endif %}
        </td>
        <td>
          {{ plugin.network_config_opts }}
        </td>
        <td>
          {{ plugin.notes }}
        </td>
      </tr>
    {% endfor %}
  </tbody>
</table>

{% endfor %}

### Deployment

[Deployment plugins](/hub) are not bundled with any version of Konnect, and are
simply tools to help you deploy Kong Gateway in various environments.
