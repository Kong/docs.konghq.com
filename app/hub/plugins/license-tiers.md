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
      </tr>
    {% endfor %}
  </tbody>
</table>

{% endfor %}