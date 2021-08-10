---
title: Kong Vitals with Prometheus
---

For using Vitals with a database as the backend (i.e. PostgreSQL, Cassandra), 
please refer to [Kong Vitals](/enterprise/{{page.kong_version}}/vitals/).

## Setup Prometheus environment for Vitals

### Download Prometheus

The latest release of Prometheus can be found at the [Prometheus download page](https://prometheus.io/download/#prometheus).

Prometheus should be running on a separate node from the one running Kong.
For users that are already using Prometheus in their infrastructure, it's
possible to use existing Prometheus nodes as Vitals storage backend.

In this guide, we assume Prometheus is running on hostname `prometheus-node`
using default config that listens on port `9090`.

### Download and configure StatsD exporter

{% include /md/enterprise/download/statsd.md kong_version=page.kong_version version='0.34' %}

### Configure Prometheus to scrape StatsD exporter

To configure Prometheus to scrape StatsD exporter, add the following section to
`scrape_configs` in `prometheus.yaml`.

```yaml
scrape_configs:
  - job_name: 'vitals_statsd_exporter'
    scrape_interval: "5s"
    static_configs:
      - targets: ['statsd-node:9102']
```

Please update `statsd-node` with the actual hostname that runs StatsD exporter.

If you are using service discovery, it will be more convenient to configure
multiple StatsD exporters in Prometheus. Please refer to the 
[scape_configs](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#%3Cscrape_config%3E)
section of Prometheus document for further reading.

By default, the Vitals graph in Kong Manager uses the configured target address
in the legend, which is named `instance` in the Prometheus metrics label. For some service
discovery setups where `instance` is `IP:PORT`, the user might want to relabel the `instance`
label to display a more meaningful hostname in the legend.
To do so, the user can also refer to the [scape_configs](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#%3Cscrape_config%3E)
section and rewrite the `instance` label with the corresponding meta label.

For example, in a Kubernetes environment, use the following relabel rules:

```yaml
scrape_configs:
  - job_name: 'vitals_statsd_exporter'
    kubernetes_sd_configs:
      # your SD config to filter statsd exporter pods
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_name]
        action: replace
        target_label: 'instance'
```

### Enable Vitals with Prometheus strategy in Kong

You can change this in your configuration to enable Vitals with Prometheus:

```bash
# via your Kong configuration file
vitals = on
vitals_strategy = prometheus
vitals_statsd_address = statsd-node:9125
vitals_tsdb_address = prometheus-node:9090
```

```bash
# or via environment variables
$ export KONG_VITALS=on
$ export KONG_VITALS_STRATEGY=prometheus
$ export KONG_VITALS_STATSD_ADDRESS=statsd-node:9125
$ export KONG_VITALS_TSDB_ADDRESS=prometheus-node:9090
```

Please update `statsd-node` and `prometheus-node` with the actual hostname that
runs StatsD exporter and Prometheus.

As with other Kong configurations, your changes take effect on `kong reload` or
`kong restart`.

If you set `scrape_interval` in Prometheus other than the default value of `5`
seconds, you will also need to update the following:

```bash
# via your Kong configuration file
vitals_prometheus_scrape_interval = new_value_in_seconds
```

```bash
# or via environment variables
$ export KONG_VITALS_PROMETHEUS_SCRAPE_INTERVAL=new_value_in_seconds
```

The above option configures `interval` parameter when quering Prometheus.
The value `new_value_in_seconds` should be equal or larger than
`scrape_interval` config in Prometheus. 

You can also configure Kong to send StatsD events with a different prefix from
the default value of `kong`. Make sure the prefix in statsd.rules
is same as that in Kong configuration:

```bash
# via your Kong configuration file
vitals_statsd_prefix = kong-vitals
```

```bash
# or via environment variables
$ export KONG_VITALS_STATSD_PREFIX=kong-vitals
```

```yaml
# in statsd.rules
mappings:
# by API
- match: kong-vitals.api.*.request.count
  name: "kong_requests_proxy"
  labels:
    job: "kong_metrics"
# follows other metrics
# ...
```

### Install Grafana dashboard

If you use Grafana, you can import the Kong Vitals Prometheus dashboard to visualize the data.

In your Grafana installation, click the **+** button in the sidebar, and choose **Import**.

On the **Import** screen, find the **Grafana.com Dashboard** field and enter `11870`. Then, click **Load**. Optionally, you
can also download the JSON model from [https://grafana.com/grafana/dashboards/11870](https://grafana.com/grafana/dashboards/11870) and import it manually.

On the next screen, select the **Prometheus** datasource that is configured to scrape `statsd-exporter`, then
click **Import**.

## Tunning and Optimization

### StatsD exporter UDP buffer

As the amount of concurrent requests increases, the length of the queue to store
unprocessed UDP events will grow as well.
It's necessary to increase the UDP read buffer size to avoid possible packet
dropping.

To increase the UDP read buffer for the StatsD exporter process, run the binary
using the following example to set read buffer to around 3 MB:

```
$ ./statsd_exporter --statsd.mapping-config=statsd.rules.yaml \
                    --statsd.listen-unixgram='' \
                    --statsd.read-buffer=30000000
```

To increase the UDP read buffer for the host that's running, adding the
following example line to `/etc/sysctl.conf`:

```
net.core.rmem_max = 60000000
```

And then apply the setting with root privilege:

```
# sysctl -p
```

### StatsD exporter with Unix domain socket

It is possible to further reduce network overhead by deploying StatsD exporter
on the same node with Kong and let the exporter listen on local Unix domain
socket.

```bash
$ ./statsd_exporter --statsd.mapping-config=statsd.rules.yaml \
                    --statsd.read-buffer=30000000 \
                    --statsd.listen-unixgram='/tmp/statsd.sock' 
```

By default the socket is created with permission `0755`, so that StatsD exporter
 has to be running with the same user with Kong to allow Kong to write UDP
 packets to the socket. To allow the exporter and Kong to run as different
 users, the socket can be created with permission `0777` with the following:

```bash
$ ./statsd_exporter --statsd.mapping-config=statsd.rules.yaml \
                    --statsd.read-buffer=30000000 \
                    --statsd.listen-unixgram='/tmp/statsd.sock' \
                    --statsd.unixsocket-umask="777" 
```


## Accessing Vitals metrics from Prometheus

You can also access Kong Vitals metrics in Prometheus and display on Grafana
or setup alerting rules. With the example StatsD mapping rules, all metrics are
labeled with `exported_job=kong_vitals`. With the above Prometheus scrape config
above, all metrics are also labeled with `job=vitals_statsd_exporter`.
