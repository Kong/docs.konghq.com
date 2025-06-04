---
title: Third Party Tools
toc: false
---

These are services which are used in day to day operation of {{site.base_gateway}}. Use of these services may be optional, or they may be required by certain plugins.

Unless otherwise noted, Kong supports the last 2 versions any third party tool, plus the current managed version if available.

{:.note}
> Some third party tools below do not have a version number. These tools are managed services and Kong provides compatibility with the currently released version

{% navtabs %}
  {% navtab 3.10 LTS %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.310 %}
  {% endnavtab %}
  {% navtab 3.9 %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.39 %}
  {% endnavtab %}
  {% navtab 3.8 %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.38 %}
  {% endnavtab %}
  {% navtab 3.4 LTS %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.34 %}
  {% endnavtab %}
{% endnavtabs %}
