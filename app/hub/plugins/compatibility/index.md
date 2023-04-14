---
title: Plugin Compatibility
no_version: true
layout: plugins/introduction
---

Reference for plugin compatibility with {{site.base_gateway}} and {{site.konnect_short_name}} [deployment topologies](#deployment-topologies), [network protocols](#protocols), and [entity scopes](#scopes).

If you're looking for plugin availability by subscription tier, see [Plugin License Tiers](/hub/plugins/license-tiers/).

## Deployment topologies

{{site.base_gateway}} can be deployed in the following modes:

* **Self-managed**: Use any hosting service of your choice or host {{site.base_gateway}} on-premises,
with any of the following network configurations:
    * [**Traditional:**](/gateway/latest/production/deployment-topologies/traditional/)
    Every node is connected to a database. Refers to a classic
    deployment on any platform, including Kubernetes.
    * [**DB-less:**](/gateway/latest/production/deployment-topologies/db-less-and-declarative-config/) 
    Deployed without a database (available in {{site.ce_product_name}}
    1.1 and {{site.ee_product_name}} 2.4 onward). Admin API is read-only,
    except for the `/config` endpoint. Refers to a DB-less deployment on any
    platform, including Kubernetes.
    * [**Hybrid mode:**](/gateway/latest/production/deployment-topologies/hybrid-mode/) 
    Nodes are split into control plane and data plane roles.
    The control plane coordinates configuration and propagates it to data plane
    nodes, so only control plane nodes require a database
    (available in {{site.ce_product_name}} 2.0 and {{site.ee_product_name}} 2.1 onward).

* **{{site.konnect_short_name}} (Kong-hosted cloud)**: Hybrid deployment. Nodes are split into control plane and
data plane roles. Kong provides and hosts the control plane and a database with
{{site.konnect_product_name}}, and you provide the {{site.base_gateway}} data plane nodes (no databases required).


{% assign hub = site.data.ssg_hub %}
{% assign kong_extns = hub | where: "extn_publisher", "kong-inc" %}

{% assign categories = site.extensions.categories %}

{% for category in categories %}
<h3 id="{{ category.slug }}">
  {{ category.name }}
</h3>

<table>
  <thead>
      <th style="text-align: left; width: 10%">Plugin</th>
      <th style="text-align: center">Traditional</th>
      <th style="text-align: center">DB-less</th>
      <th style="text-align: center">Hybrid mode</th>
      <th style="text-align: center">Konnect </th>
      <th style="text-align: left; width: 35%">Notes</th>
  </thead>
  <tbody>
    {% assign plugins_for_category = kong_extns | where_exp: "plugin", "plugin.categories contains category.slug" %}
    {% for plugin in plugins_for_category %}
      {% assign n = plugin.network_config_opts | downcase %}
      <tr>
        <td>
          <a href="{{plugin.url}}">{{ plugin.name }}</a>
        </td>
        <td style="text-align: center">
          {% if n == "all" or n contains "traditional" %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
        <td style="text-align: center">
          {% if n == "all" or n contains "db-less" %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
        <td style="text-align: center">
          {% if n == "all" or n contains "hybrid" %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
         <td style="text-align: center">
          {% if plugin.konnect == true %}
            <i class="fa fa-check"></i>
          {% elsif plugin.konnect == false %}
            <i class="fa fa-times"></i>
          {% endif %}
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

[Deployment plugins](/hub/#deployment) are not bundled with any version of {{site.base_gateway}} or {{site.konnect_short_name}}, and are
simply tools to help you deploy {{ site.base_gateway }} in various environments.

## Protocols

{{site.base_gateway}} and {{site.konnect_short_name}} plugins are compatible with the following protocols:

<table class="table-sticky">
  <thead>
      <th>Plugin</th>
      <th><code>http</code></th>
      <th><code>https</code></th>
      <th><code>grpc</code></th>
      <th><code>grpcs</code></th>
      <th><code>tcp</code></th>
      <th><code>tls</code></th>
      <th><code>tls_ passthrough</code></th>
      <th><code>udp</code></th>
      <th><code>ws</code></th>
      <th><code>wss</code></th>
  </thead>
  <tbody>
  {% for extn in kong_extns %}
    <tr>
      <td>
      <a href="{{extn.url}}">{{ extn.name }}</a>
      </td>
      {% if extn.schema.protocols.size == 0 %}
        <td style="text-align: center">N/A</td>
        <td style="text-align: center">N/A</td>
        <td style="text-align: center">N/A</td>
        <td style="text-align: center">N/A</td>
        <td style="text-align: center">N/A</td>
        <td style="text-align: center">N/A</td>
        <td style="text-align: center">N/A</td>
        <td style="text-align: center">N/A</td>
        <td style="text-align: center">N/A</td>
        <td style="text-align: center">N/A</td>
      {% else %}
        {% assign protocols = extn.schema.protocols %}
        <td style="text-align: center"> 
          {% if protocols contains "http" %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
        <td style="text-align: center">
          {% if protocols contains "https" %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
        <td style="text-align: center">
          {% if protocols contains "grpc" %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}  
        </td>
        <td style="text-align: center">
          {% if protocols contains "grpcs" %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}  
        </td>
        <td style="text-align: center">
          {% if protocols contains "tcp" %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}  
        </td>
        <td style="text-align: center">
          {% if protocols contains "tls" %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}  
        </td>
        <td style="text-align: center">
          {% if protocols contains "tls_passthrough" %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}  
        </td>
        <td style="text-align: center">
          {% if protocols contains "udp" %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}  
        </td>
        <td style="text-align: center">
          {% if protocols contains "ws" %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}  
        </td>
        <td style="text-align: center">
          {% if protocols contains "wss" %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}  
        </td>
      {% endif %}
    </tr>
  {% endfor %}
  </tbody>
</table>

## Scopes

Plugins can be scoped or global (without scope):
* Scoped plugin: Plugin applied to a specific service, route, or consumer.
* Global plugin: Plugin applies either to your entire environment, or if running {{site.ee_product_name}}, your entire workspace.

See the following table for plugins and their compatible scopes:
<table class="table-sticky">
  <thead>
      <th style="text-align: left; width: 10%">Plugin</th>
      <th style="text-align: center">Service</th>
      <th style="text-align: center">Route</th>
      <th style="text-align: center">Consumer</th>
      <th style="text-align: center">Global</th>
  </thead>
  <tbody>
    {% for extn in kong_extns %}
      <tr>
        <td>
        <a href="{{extn.url}}">{{ extn.name }}</a>
        </td>
        <td style="text-align: center"> 
          {% if extn.schema.enable_on_service? %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
        <td style="text-align: center"> 
          {% if extn.schema.enable_on_route? %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
        <td style="text-align: center"> 
          {% if extn.schema.enable_on_consumer? %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
        <td style="text-align: center"> 
          {% if extn.schema.global? %}
            <i class="fa fa-check"></i>
          {% else %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
      </tr>
    {% endfor %}
  </tbody>
</table>
