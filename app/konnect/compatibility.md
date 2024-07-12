---
title: Compatibility
---

## Supported browsers

|                                  | IE | Edge | Firefox | Chrome | Safari |
|----------------------------------|:--:|:----:|:-------:|:------:|:------:|
| {{site.konnect_saas}} |  <i class="fa fa-times"></i> | <i class="fa fa-check"></i> |  <i class="fa fa-check"></i> |  <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |

## {{site.base_gateway}} version compatibility


|                                | {{site.konnect_saas}} | Beginning with version | End of support | 
|--------------------------------|:---------------------:|-------------------------------|----------------|
| {{site.ee_product_name}} 3.6.x | <i class="fa fa-check"></i>    | 3.6.0.0 | Feb 2025 
| {{site.ee_product_name}} 3.5.x | <i class="fa fa-check"></i>    | 3.5.0.0 | Nov 2024 
| {{site.ee_product_name}} 3.4.x (LTS)| <i class="fa fa-check"></i>    | 3.4.0.0 | Aug 2026 
| {{site.ee_product_name}} 3.3.x | <i class="fa fa-check"></i>    | 3.3.0.0 | May 2024
| {{site.ee_product_name}} 3.2.x | <i class="fa fa-check"></i>    | 3.2.1.0 | Feb 2024
| {{site.ee_product_name}} 3.1.x | <i class="fa fa-check"></i>    | 3.1.0.0 | Dec 2023
| {{site.ee_product_name}} 3.0.x | <i class="fa fa-check"></i>    | 3.0.0.0 | Sep 2023
| {{site.ee_product_name}} 2.8.x (LTS)| <i class="fa fa-check"></i>    | 2.8.0.0 | Mar 2025 
| {{site.ee_product_name}} 2.7.x | <i class="fa fa-check"></i>    | 2.7.0.0 | Feb 2023
| {{site.ee_product_name}} 2.6.x | <i class="fa fa-check"></i>    | 2.6.0.0 | Feb 2023
| {{site.ee_product_name}} 2.5.x | <i class="fa fa-check"></i>    | 2.5.0.1 | Aug 2022
| {{site.ee_product_name}} 2.4.x or earlier | <i class="fa fa-times"></i>    | -- | -- 



## {{site.mesh_product_name}} compatibility

To use [Mesh Manager](/konnect/mesh-manager/), you must also use a compatible version of {{site.mesh_product_name}}. 

|                                  | {{site.konnect_saas}} | First supported patch version
|--------------------------------|:---------------------:|-----------------------------
| {{site.mesh_product_name}} 2.4.x | <i class="fa fa-check"></i> | 2.4.1
| {{site.mesh_product_name}} 2.3.x or earlier | <i class="fa fa-times"></i> | -


## Plugin compatibility

There are three tiers of plugins available in {{site.konnect_saas}}:

* [**Free tier**](/hub/?tier=free&compatibility=konnect)
* [**Paid tier**](/hub/?tier=paid&compatibility=konnect)
* [**Premium tier**](/hub/?tier=premium&compatibility=konnect)

The tiers denote plugin pricing. See the [{{site.konnect_short_name}} pricing page](https://konghq.com/pricing) for more detail. 

If you're looking for supported network protocols and entity scopes, see [Plugin Compatibility](/hub/plugins/compatibility/) on the Plugin Hub.

### Considerations for Dedicated Cloud Gateways

There are some limitations for plugins with Dedicated Cloud Gateways:

* Any plugins that depend on a local agent will not work with Dedicated Cloud Gateways.
* Any plugins that depend on the Status API or on Admin API endpoints will not work.
* Any plugins or functionality that depend on AWS IAM `AssumeRole` need to be configured differently. 
This includes [Data Plane Resilience](/gateway/latest/kong-enterprise/cp-outage-handling/).

See the following table for details on each plugin.

### Plugin tiers

{% assign hub = site.data.ssg_hub %}
{% assign kong_extns = hub | where: "extn_publisher", "kong-inc" %}
{% assign categories = site.extensions.categories %}
{% assign plugins = site.data.ssg_hub | where: "extn_publisher", "kong-inc" %}

{% for category in categories %}
<h3 id="{{ category.slug }}">
  {{ category.name }}
</h3>

<table>
  <thead>
      <th style="text-align: left; width: 10%">Plugin</th>
      <th style="text-align: center">Free</th>
      <th style="text-align: center">Paid</th>
      <th style="text-align: center">Premium</th>

      <th style="text-align: left; width: 35%">Notes</th>
  </thead>
  <tbody>
    {% assign plugins_for_category = kong_extns | where_exp: "plugin", "plugin.categories contains category.slug" %}
    {% for plugin in plugins_for_category %}
      <tr>
        <td>
          <a href="{{plugin.url}}">{{ plugin.name }}</a>
        </td>
        <td style="text-align: center">
        {% if plugin.konnect == false %}
         <span></span>
        {% elsif plugin.free == true %}
          <i class="fa fa-check"></i>
        {% endif %}
        </td>
        <td style="text-align: center">
          {% unless plugin.konnect %}
            <span>Not available in {{site.konnect_short_name}}</span>
          {% else %}
            {% unless plugin.free %}
              {% unless plugin.premium %}
                {% if plugin.paid == true %}
                  <i class="fa fa-check"></i>
                {% endif %}
              {% endunless %}
            {% endunless %}
          {% endunless %}
        </td>
        <td style="text-align: center">
          {% unless plugin.konnect %}
            <span></span>
          {% else %}
            {% unless plugin.free %}
              {% unless plugin.paid %}
                {% if plugin.premium == true %}
                  <i class="fa fa-check"></i>
                {% endif %}
              {% endunless %}
            {% endunless %}
          {% endunless %}
        </td>
    
        <td>
          {{ plugin.notes | markdownify }}
        </td>
      </tr>

    {% endfor %}
  </tbody>
</table>

{% endfor %}

