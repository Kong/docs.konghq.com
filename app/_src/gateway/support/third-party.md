---
title: Third Party Tools
toc: false
---

These are services which are used in day to day operation of {{site.base_gateway}}. Use of these services may be optional, or they may be required by certain plugins.

Unless otherwise noted, Kong supports the last 2 versions any third party tool, plus the current managed version if available.

{:.note}
> Some third party tools below do not have a version number. These tools are managed services and Kong provides compatibility with the currently released version

{% navtabs %}
  {% if_version gte: 3.10.x %}
  {% navtab 3.10 LTS %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.310 %}
  {% endnavtab %}
  {% endif_version %}
  {% if_version gte: 3.9.x %}
  {% navtab 3.9 %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.39 %}
  {% endnavtab %}
  {% endif_version %}
  {% if_version gte: 3.8.x %}
  {% navtab 3.8 %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.38 %}
  {% endnavtab %}
  {% endif_version %}
  {% if_version gte: 3.7.x %}
  {% navtab 3.7 %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.37 %}
  {% endnavtab %}
  {% endif_version %}
  {% navtab 3.4 LTS %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.34 %}
  {% endnavtab %}
{% endnavtabs %}
