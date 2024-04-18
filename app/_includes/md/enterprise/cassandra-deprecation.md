{% if include.length == "short" %}

We don't recommend using Cassandra with {{site.base_gateway}},
because support for Cassandra is [deprecated and planned to be removed](/gateway/{{include.release}}/reference/configuration/#cassandra-settings).

{% else %}

{:.warning .no-icon}
> **Deprecation warning:** Cassandra as a backend database for {{site.base_gateway}}
is deprecated. Support for Cassandra will be removed in a future release.
> <br>
> Our target for Cassandra removal is the {{site.base_gateway}} 3.4 release.
Starting with the {{site.base_gateway}} 3.0 release, some new features might
not be supported with Cassandra.

{% endif %}
