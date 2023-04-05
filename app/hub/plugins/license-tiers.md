---
title: Plugin License Tiers
header_title: Plugin License Tiers
type: concept
layout: extension
---

<!-- To add or edit table entries in this topic, see /app/_data/tables/plugin_index.yml in this repo -->

Each [subscription tier](https://konghq.com/pricing) gives you
access to a subset of plugins:

* **Free tier:** Open-source {{site.base_gateway}} plugins. Available in:
    * {{site.konnect_short_name}} Free tier
    * {{site.base_gateway}} Free tier (Enterprise package, self-managed)
    * {{site.ce_product_name}} (open-source package, self-managed)
* **Plus tier:** Open-source and Plus-specific plugins. The Plus tier is a {{site.konnect_short_name}} subscription tier only.
* **Enterprise tier:** All Kong plugins. Available in:
    * {{site.konnect_short_name}} Enterprise tier
    * {{site.ee_product_name}} (self-managed)

If you're looking for plugin deployment topology compatibility, supported network protocols, and supported entity scopes, see [Plugin Compatibility](/hub/plugins/compatibility/).

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
      <th style="text-align: center">Plus</th>
      <th style="text-align: center">Enterprise</th>
  </thead>
  <tbody>
    {% assign plugins_for_category = kong_extns | where_exp: "plugin", "plugin.metadata.categories contains category.slug" %}
    {% for plugin in plugins_for_category %}
      <tr>
        <td>
          <a href="{{plugin.url}}">{{ plugin.name }}</a>
        </td>
        <td style="text-align: center">
          {% if plugin.metadata.free == true %}
            <i class="fa fa-check"></i>
          {% elsif plugin.metadata.free == false %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
        <td style="text-align: center">
          {% if plugin.metadata.plus == true %}
            <i class="fa fa-check"></i>
          {% elsif plugin.metadata.plus == false %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
        <td style="text-align: center">
          {% if plugin.metadata.enterprise == true %}
            <i class="fa fa-check"></i>
          {% elsif plugin.metadata.enterprise == false %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
      </tr>
    {% endfor %}
  </tbody>
</table>

{% endfor %}
