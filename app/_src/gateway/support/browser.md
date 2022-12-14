---
title: Browser Support
breadcrumb: Browser
---

[Edge](https://blogs.windows.com/msedgedev/2021/07/15/opt-in-extended-stable-release-cycle/), [Chrome](https://support.google.com/chrome/a/answer/9027636?hl=en) and [Firefox](https://support.mozilla.org/en-US/kb/switch-to-firefox-extended-support-release-esr) release a new major version every 4 weeks, with extended support available for 8 weeks.

Kong supports N-1 versions of Edge, Chrome, Firefox and Safari on desktop plus any extended support versions.

{% navtabs %}
  {% navtab 2.8 LTS %}
    {% include_cached gateway-support-browsers.html data=site.data.tables.support.gateway.lts-28 %}
  {% endnavtab %}
  {% navtab 3.x %}
    {% include_cached gateway-support-browsers.html data=site.data.tables.support.gateway.3x %}
  {% endnavtab %}
{% endnavtabs %}