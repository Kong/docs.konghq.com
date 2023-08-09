---
title: Version Compatibility
toc: false
---

This page lists compatibility with other product releases for this section's
{{site.kic_product_name}} release and several versions prior to it. Older
version compatibility information is available in that version's documentation
section.

{% navtabs %}
  {% navtab 2.11 %}
    {% include_cached kic-support.md data=site.data.tables.support.kic.versions.211 %}
  {% endnavtab %}
  {% navtab 2.10 %}
    {% include_cached kic-support.md data=site.data.tables.support.kic.versions.210 %}
  {% endnavtab %}
  {% navtab 2.9 %}
    {% include_cached kic-support.md data=site.data.tables.support.kic.versions.29 %}
  {% endnavtab %}
  {% navtab 2.8 %}
    {% include_cached kic-support.md data=site.data.tables.support.kic.versions.28 %}
  {% endnavtab %}
  {% navtab 2.7 %}
    {% include_cached kic-support.md data=site.data.tables.support.kic.versions.27 %}
  {% endnavtab %}
  {% navtab 2.6 %}
    {% include_cached kic-support.md data=site.data.tables.support.kic.versions.26 %}
  {% endnavtab %}
{% endnavtabs %}

[comment]: <> This page is rendered from app/_includes/kic-support.md
[comment]: <> To add a new version, copy the latest version under app/_data/tables/support/kic/versions/ to a new file and add a tab above.
[comment]: <> To add a new Kong/Kubernetes/etc. version, update app/_data/tables/support/kic/base.yml and add min/max overrides to any KIC versions that need them.
