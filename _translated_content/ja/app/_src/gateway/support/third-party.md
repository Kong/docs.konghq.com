---
title: サードパーティツール
toc: false
---

これらは{{site.base_gateway}}の日常運用で使用されるサービスです。これらのサービスの使用は任意である場合もありますし、特定のプラグインによって必要とされる場合もあります。

特に記載されていない限り、Kongは最新の2つのバージョンのいずれかのサードパーティツールをサポートし、利用可能な場合は現在の管理されているバージョンもサポートします。

{:.note}
> 以下のいくつかのサードパーティツールにはバージョン番号がありません。これらのツールは管理されたサービスであり、Kongは現在リリースされているバージョンとの互換性を提供します

{% navtabs %}
  {% if_version gte: 3.6.x %}
  {% navtab 3.6 %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.36 %}
  {% endnavtab %}
  {% endif_version %}
  {% navtab 3.5 %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.35 %}
  {% endnavtab %}
  {% navtab 3.4 %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.34 %}
  {% endnavtab %}
  {% navtab 3.3 %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.33 %}
  {% endnavtab %}
  {% navtab 2.8 LTS %}
    {% include_cached gateway-support-third-party.html data=site.data.tables.support.gateway.versions.28 %}
  {% endnavtab %}
{% endnavtabs %}

