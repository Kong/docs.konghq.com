---
title: Kong Gateway Compatibility
---

Provided below are compatibility tables for {{site.base_gateway}}. Select a version
to see technologies that have been tested for interoperability with the Kong platform.

Please see [{{site.base_gateway}} Version Support](/gateway/latest/support-policy/)
for more information about Kong's support for {{site.base_gateway}} and our
[Support & Maintenance Policy](https://konghq.com/supportandmaintenancepolicy).

{% assign compat_data = site.data.tables.compat[page.release.value] %}

{% unless compat_data %}
{% assign msg = "compat.json data is missing for Gateway " | append: page.release %}
{{ msg | raise_error }}
{% endunless %}

<p> If you need help using {{site.base_gateway}} with any of the supported technologies, ask a question in <a href="https://discuss.konghq.com/">our community</a>.</p>

<p>If you have an Enterprise tier subscription, contact <a href="https://support.konghq.com/">Kong Support</a>.</p>

<h3>Supported operating systems</h3>
<ul>
{% for system in compat_data.os %}
  <li><strong>{{ system[0] | split: "-" | join: " " | capitalize }}:</strong> {{ system[1] }}</li>
{% endfor %}

Kong only supports the latest vendor-supported minor version for RHEL and CentOS.
</ul>

<h3>Supported databases</h3>
<ul>
{% for db in compat_data.databases %}
  <li><strong>{{ db[0] | capitalize }}:</strong> {{ db[1] }}</li>
{% endfor %}
</ul>
