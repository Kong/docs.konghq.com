---
title: Version Compatibility
toc: false
---

This page lists compatibility with other product releases for this section's
{{site.kic_product_name}} release and several versions prior to it. Older
version compatibility information is available in that version's documentation
section.

{% navtabs %}
  {% for version_hash in site.data.tables.support.kic.versions %}
    {% assign versioninfo = version_hash[1] %}
    {% assign name = versioninfo.version | string %}
    {% navtab name %}
      {% include_cached kic-support.md data=versioninfo %}
    {% endnavtab %}
  {% endfor %}
  {% navtab static_example %}
    {% include_cached kic-support.md data=site.data.tables.support.kic.versions.211 %}
  {% endnavtab %}
{% endnavtabs %}

[comment]: <> This page is rendered from app/_includes/kic-support.md
[comment]: <> To add a new version, copy the latest version under app/_data/tables/support/kic/versions/ to a new file and add a tab above.
[comment]: <> To add a new Kong/Kubernetes/etc. version, update app/_data/tables/support/kic/base.yml and add min/max overrides to any KIC versions that need them.
