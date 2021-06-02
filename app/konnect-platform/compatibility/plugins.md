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

### Supported topologies

Some plugins can't be deployed in every {{site.konnect_short_name}} topology.
{{site.konnect_short_name}} can be deployed in the following ways:

* **Kong-hosted cloud**: Hybrid deployment. Nodes are split into control plane and
data plane roles. Kong provides and hosts the control plane and its database through
{{site.konnect_saas}}, and you provide the data plane nodes.

* **Self-managed**: Using any hosting service of your choice or hosting
on-premises, with any of the following topologies:
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

For details on the differences between deployment types, see
[Kong Deployment Options](/enterprise/latest/deployment/deployment-options)
and [{{site.ee_product_name}} for Kubernetes Deployment Options](/enterprise/latest/deployment/kubernetes-deployment-options/).

{% assign plugins=site.data.tables.plugins %}

## Plugin Tiers and Topologies

<!-- To add or edit table entries in this topic, see /app/_data/tables/plugins.yml in this repo -->

### Authentication

<table>
      <thead>
         <th style="text-align: left; width: 10%">Plugin</th>
         <th style="text-align: center">Free</th>
         <th style="text-align: center">Plus</th>
         <th style="text-align: center">Enterprise</th>
         <th style="width: 20%">Supported Topologies</th>
         <th style="text-align: left; width: 35%">Notes</th>
      </thead>
      <tbody>
        {% for plugin in plugins %}
          {% if plugin.category == 'Authentication' %}
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
            {{ plugin.topologies }}
            </td>
            <td>
            {{ plugin.notes }}
            </td>
          </tr>
          {% endif %}
        {% endfor %}
      </tbody>
</table>

### Security

<table>
      <thead>
         <th style="text-align: left">Plugin</th>
         <th style="text-align: center">Free</th>
         <th style="text-align: center">Plus</th>
         <th style="text-align: center">Enterprise</th>
         <th style="width: 20%">Supported Topologies</th>
         <th style="text-align: left; width: 35%">Notes</th>
      </thead>
      <tbody>
        {% for plugin in plugins %}
          {% if plugin.category == 'Security' %}
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
            {{ plugin.topologies }}
            </td>
            <td>
            {{ plugin.notes }}
            </td>
          </tr>
          {% endif %}
        {% endfor %}
      </tbody>
</table>


### Traffic Control

<table>
      <thead>
         <th style="text-align: left; width: 15%">Plugin</th>
         <th style="text-align: center">Free</th>
         <th style="text-align: center">Plus</th>
         <th style="text-align: center">Enterprise</th>
         <th style="width: 20%">Supported Topologies</th>
         <th style="text-align: left; width: 35%">Notes</th>
      </thead>
      <tbody>
        {% for plugin in plugins %}
          {% if plugin.category == 'Traffic Control' %}
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
            {{ plugin.topologies }}
            </td>
            <td>
            {{ plugin.notes }}
            </td>
          </tr>
          {% endif %}
        {% endfor %}
      </tbody>
</table>

### Serverless

<table>
      <thead>
         <th style="text-align: left; width: 15%">Plugin</th>
         <th style="text-align: center">Free</th>
         <th style="text-align: center">Plus</th>
         <th style="text-align: center">Enterprise</th>
         <th style="width: 20%">Supported Topologies</th>
         <th style="text-align: left; width: 35%">Notes</th>
      </thead>
      <tbody>
        {% for plugin in plugins %}
          {% if plugin.category == 'Serverless' %}
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
            {{ plugin.topologies }}
            </td>
            <td>
            {{ plugin.notes }}
            </td>
          </tr>
          {% endif %}
        {% endfor %}
      </tbody>
</table>

### Analytics and Monitoring

<table>
      <thead>
         <th style="text-align: left; width: 15%">Plugin</th>
         <th style="text-align: center">Free</th>
         <th style="text-align: center">Plus</th>
         <th style="text-align: center">Enterprise</th>
         <th style="width: 20%">Supported Topologies</th>
         <th style="text-align: left; width: 35%">Notes</th>
      </thead>
      <tbody>
        {% for plugin in plugins %}
          {% if plugin.category == 'Analytics and Monitoring' %}
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
            {{ plugin.topologies }}
            </td>
            <td>
            {{ plugin.notes }}
            </td>
          </tr>
          {% endif %}
        {% endfor %}
      </tbody>
</table>

### Transformations

<table>
      <thead>
         <th style="text-align: left; width: 15%">Plugin</th>
         <th style="text-align: center">Free</th>
         <th style="text-align: center">Plus</th>
         <th style="text-align: center">Enterprise</th>
         <th style="width: 20%">Supported Topologies</th>
         <th style="text-align: left; width: 35%">Notes</th>
      </thead>
      <tbody>
        {% for plugin in plugins %}
          {% if plugin.category == 'Transformations' %}
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
            {{ plugin.topologies }}
            </td>
            <td>
            {{ plugin.notes }}
            </td>
          </tr>
          {% endif %}
        {% endfor %}
      </tbody>
</table>

### Logging

<table>
      <thead>
         <th style="text-align: left; width: 15%">Plugin</th>
         <th style="text-align: center">Free</th>
         <th style="text-align: center">Plus</th>
         <th style="text-align: center">Enterprise</th>
         <th style="width: 20%">Supported Topologies</th>
         <th style="text-align: left; width: 35%">Notes</th>
      </thead>
      <tbody>
        {% for plugin in plugins %}
          {% if plugin.category == 'Logging' %}
          <tr>
            <td>
            <a href="{{plugin.url}}"><a href="{{plugin.url}}">{{ plugin.name }}</a></a>
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
            {{ plugin.topologies }}
            </td>
            <td>
            {{ plugin.notes }}
            </td>
          </tr>
          {% endif %}
        {% endfor %}
      </tbody>
</table>

### Deployment

[Deployment plugins](/hub) are not bundled with any version of Konnect, and are
simply tools to help you deploy Kong Gateway in various environments.
