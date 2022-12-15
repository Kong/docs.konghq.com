---
title: Third Party Tools
toc: false
---

These are services which are used in day to day operation of Kong Gateway. Use of these services may be optional, or they may be required by certain plugins.

Kong aims to support the last 2 versions of any third party tool, plus the current managed version if available.

{:.note}
> Some third party tools below do not have a version number. These tools are managed services and Kong provides compatibility with the currently released version

{% navtabs %}
  {% navtab 2.6 %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.2x %}
  {% endnavtab %}
   {% navtab 2.7 %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.2x %}
  {% endnavtab %}
   {% navtab 2.8 LTS %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.2x %}
  {% endnavtab %}
  {% navtab 3.0 %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.3x %}
  {% endnavtab %}
  {% navtab 3.1 %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.3x %}
  {% endnavtab %}
{% endnavtabs %}