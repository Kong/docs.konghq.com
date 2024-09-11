---
title: Kong Gateway Plugin License Tiers
header_title: Kong Gateway Plugin License Tiers
type: reference
layout: plugins/introduction
---

Each {{site.base_gateway}} [subscription tier](https://konghq.com/pricing) gives you
access to a subset of plugins.

* **Free tier:** Open-source {{site.base_gateway}} plugins. Available in:
    * {{site.base_gateway}} Free tier (Enterprise package, self-managed)
    * {{site.ce_product_name}} (open-source package, self-managed)
* **Enterprise tier:** All Kong plugins. Available in:
    * {{site.ee_product_name}} (self-managed)
If you're looking for plugin deployment topology compatibility, supported network protocols, and supported entity scopes, see [Plugin Compatibility](/hub/plugins/compatibility/).

{:.note}
> In {{site.konnect_short_name}}, you have access to all plugins, regardless of your subscription tier &mdash; as long as the plugins are [compatible with {{site.konnect_short_name}}](/hub/?compatibility=konnect).

{% assign hub = site.data.ssg_hub %}
{% assign kong_extns = hub | where: "extn_publisher", "kong-inc" %}
{% assign categories = site.extensions.categories %}
{% assign plugins = site.data.ssg_hub | where: "extn_publisher", "kong-inc" %}

{% for category in categories %}
<h3 id="{{ category.slug }}">
  {{ category.name }}
</h3>

<table style="max-width: 700px">
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
