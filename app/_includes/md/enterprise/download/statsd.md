<!-- Download and configure for StatsD exporter for all versions in Kong EE
which is located in the vitals-prometheus-strategy.md file in the vitals folder -->

StatsD exporter is distributed as a Docker image. Pull the latest version
with the following command:

```sh
docker pull kong/statsd-exporter-advanced:0.3.1
```

The binary includes features like min/max gauges and Unix domain
socket support.

StatsD exporter needed to configured with a set of mapping rules to translate
the StatsD UDP events to Prometheus metrics. A default set of mapping rules can
be downloaded at
[statsd.rules.yaml](/enterprise/{{include.kong_version}}/plugins/statsd.rules.yaml).
Then start StatsD exporter with

```bash
$ ./statsd_exporter --statsd.mapping-config=statsd.rules.yaml \
                    --statsd.listen-unixgram=''
```

The StatsD mapping rules file must be configured to match the metrics sent from
Kong. To learn how to customize the StatsD events name, please refer to
[Enable Vitals with Prometheus strategy in Kong](#enable-Vitals-with-prometheus-strategy-in-kong)
section.

{% if include.version == "<1.3" %}
StatsD exporter can run either on a separate node from Kong (to avoid resource
competition with Kong), or on the same host with Kong (to reduce unnecessary
network overhead). Note that feeding metrics from multiple Kong nodes into a single
StatsD exporter is currently not supported, as it would result in a metrics conflict.
It's also recommended to match the number of Kong nodes to StatsD exporters for
better scalability.
{% endif %}
{% if include.version == ">=1.3" %}
StatsD exporter can run either on a separate node from Kong (to avoid resource
competition with Kong), or on the same host with Kong (to reduce unnecessary
network overhead).
{% endif %}

In this guide, we assume StatsD exporter is running on hostname `statsd-node`,
using default config that listens to UDP traffic on port `9125` and the metrics
in Prometheus Exposition Format are exposed on port `9102`.
