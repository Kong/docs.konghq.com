---
title: Plugin License Tiers
header_title: Plugin License Tiers
type: concept
layout: plugins/introduction
---

Each [subscription tier](https://konghq.com/pricing) gives you
access to a subset of plugins:

## {{site.konnect_short_name}}

{{site.konnect_short_name}} allows you to pay only for what you use with flexible pay-as-you-go billing. There are three plugin tiers categorized by pricing models:
* **Free tier:** A selection of our world-class open-source plugins available in {{site.konnect_short_name}} for free. 
* **Paid tier:** Plugins developed by Kong that are available for a monthly fee.
* **Premium tier:** Advanced plugins that are available for a monthly fee.

For more information, review the [billing page](https://konghq.com/pricing). 

If you're looking for plugin deployment topology compatibility, supported network protocols, and supported entity scopes, see [Plugin Compatibility](/hub/plugins/compatibility/).

{% assign hub = site.data.ssg_hub %}
{% assign kong_extns = hub | where: "extn_publisher", "kong-inc" %}
{% assign categories = site.data.extensions.categories %}
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
  </thead>
  <tbody>
    {% assign plugins_for_category = kong_extns | where_exp: "plugin", "plugin.categories contains category.slug" %}
    {% for plugin in plugins_for_category %}
     {% if plugin.konnect == true %}
      <tr>
        <td>
          <a href="{{plugin.url}}">{{ plugin.name }}</a>
        </td>
        <td style="text-align: center">
          {% if plugin.free == true %}
            <i class="fa fa-check"></i>

          {% endif %}
        </td>
        <td style="text-align: center">
          {% unless plugin.free %}
            {% unless plugin.premium %}
              {% if plugin.paid == true %}
                <i class="fa fa-check"></i>
              {% endif %}
            {% endunless %}
          {% endunless %}
        </td>
        <td style="text-align: center">
          {% unless plugin.free == true or plugin.paid == true %}
            {% if plugin.premium == true %}
              <i class="fa fa-check"></i>
            {% else %}
              <i class="fa fa-times"></i>
            {% endif %}
          {% endunless %}
        </td>
      </tr>
      {% endif %}
    {% endfor %}
  </tbody>
</table>

{% endfor %}



## {{site.base_gateway}}


* **Free tier:** Open-source {{site.base_gateway}} plugins. Available in:
    * {{site.base_gateway}} Free tier (Enterprise package, self-managed)
    * {{site.ce_product_name}} (open-source package, self-managed)
* **Enterprise tier:** All Kong plugins. Available in:
    * {{site.ee_product_name}} (self-managed)

If you're looking for plugin deployment topology compatibility, supported network protocols, and supported entity scopes, see [Plugin Compatibility](/hub/plugins/compatibility/).


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
      <th style="text-align: center">Enterprise</th>
  </thead>
  <tbody>
    {% assign plugins_for_category = kong_extns | where_exp: "plugin", "plugin.categories contains category.slug" %}
    {% for plugin in plugins_for_category %}
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
          {% if plugin.enterprise == true %}
            <i class="fa fa-check"></i>
          {% elsif plugin.enterprise == false %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
      </tr>
    {% endfor %}
  </tbody>
</table>

{% endfor %}
