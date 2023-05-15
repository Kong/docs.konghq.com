---
title: Compatibility
---

## Supported browsers

|                                  | IE | Edge | Firefox | Chrome | Safari |
|----------------------------------|:--:|:----:|:-------:|:------:|:------:|
| {{site.konnect_saas}} |  <i class="fa fa-times"></i> | <i class="fa fa-check"></i> |  <i class="fa fa-check"></i> |  <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |

## Runtime version compatibility

{:.note}
> **Note:** Currently, the only supported runtime type in
{{site.konnect_saas}} is a [{{site.base_gateway}}](/gateway/)
data plane.

|                                | {{site.konnect_saas}} | First supported patch version
|--------------------------------|:---------------------:|-----------------------------
| {{site.ee_product_name}} 3.2.x | <i class="fa fa-check"></i>    | 3.2.1.0
| {{site.ee_product_name}} 3.1.x | <i class="fa fa-check"></i>    | 3.1.0.0
| {{site.ee_product_name}} 3.0.x | <i class="fa fa-check"></i>    | 3.0.0.0
| {{site.ee_product_name}} 2.8.x | <i class="fa fa-check"></i>    | 2.8.0.0
| {{site.ee_product_name}} 2.7.x | <i class="fa fa-check"></i>    | 2.7.0.0
| {{site.ee_product_name}} 2.6.x | <i class="fa fa-check"></i>    | 2.6.0.0
| {{site.ee_product_name}} 2.5.x | <i class="fa fa-check"></i>    | 2.5.0.1
| {{site.ee_product_name}} 2.4.x or earlier | <i class="fa fa-times"></i>    | --


## Plugin compatibility

Each [subscription tier](https://konghq.com/pricing) gives you
access to a subset of plugins:
* **Free tier:** Open-source Kong plugins
* **Plus tier:** Open-source and Plus-specific plugins
* **Enterprise tier:** All Kong plugins

If you're looking for supported network protocols and entity scopes, see [Plugin Compatibility](/hub/plugins/compatibility/) on the Plugin Hub.

{% assign categories = site.extensions.categories %}
{% assign kong_extns = site.data.ssg_hub | where: "extn_publisher", "kong-inc" %}

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
      <th style="text-align: center">Konnect support</th>
      <th style="text-align: left; width: 35%">Notes</th>
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
         <td style="text-align: center">
          {% if plugin.metadata.konnect == true %}
            <i class="fa fa-check"></i>
          {% elsif plugin.metadata.konnect == false %}
            <i class="fa fa-times"></i>
          {% endif %}
        </td>
        <td>
          {{ plugin.metadata.notes }}
        </td>
      </tr>
    {% endfor %}
  </tbody>
</table>

{% endfor %}

### Deployment

[Deployment plugins](/hub/#deployment) are not bundled with any version of {{site.konnect_short_name}}, and are
simply tools to help you deploy {{site.base_gateway}} in various environments.
