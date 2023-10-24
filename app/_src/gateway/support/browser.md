---
title: Browser Support
breadcrumb: Browser
---

[Edge](https://blogs.windows.com/msedgedev/2021/07/15/opt-in-extended-stable-release-cycle/), [Chrome](https://www.chromium.org/chrome-release-channels/) and [Firefox](https://support.mozilla.org/en-US/kb/switch-to-firefox-extended-support-release-esr) release a new major version every 4 weeks, with extended support available for 8 weeks.

Kong supports N-1 versions of Edge, Chrome, Firefox and Safari on desktop plus any extended support versions.

{% navtabs %}
  {% navtab 3.5 %}
    {% include_cached gateway-support-browsers.html data=site.data.tables.support.gateway.versions.35 %}
  {% endnavtab %}
  {% navtab 3.4 %}
    {% include_cached gateway-support-browsers.html data=site.data.tables.support.gateway.versions.34 %}
  {% endnavtab %}
  {% navtab 3.3 %}
    {% include_cached gateway-support-browsers.html data=site.data.tables.support.gateway.versions.33 %}
  {% endnavtab %}
  {% navtab 3.2 %}
    {% include_cached gateway-support-browsers.html data=site.data.tables.support.gateway.versions.32 %}
  {% endnavtab %}
  {% navtab 3.1 %}
    {% include_cached gateway-support-browsers.html data=site.data.tables.support.gateway.versions.31 %}
  {% endnavtab %}
  {% navtab 2.8 LTS %}
    {% include_cached gateway-support-browsers.html data=site.data.tables.support.gateway.versions.28 %}
  {% endnavtab %}
{% endnavtabs %}
