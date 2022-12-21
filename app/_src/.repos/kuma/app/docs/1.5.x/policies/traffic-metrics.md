---
title: Traffic Metrics
---

Kuma facilitates consistent traffic metrics across all data plane proxies in your mesh.

You can add metrics to a mesh configuration, or to an individual data plane proxy configuration. For example, you might need metrics for individual data plane proxies to override the default metrics port if it's already in use on the specified machine.

Kuma provides full integration with Prometheus:

* Each proxy can expose its metrics in `Prometheus` format.
* Because metrics are part of the mesh configuration, Prometheus can automatically find every proxy in the mesh.

To collect metrics from Kuma, you first expose metrics from proxies and then configure Prometheus to collect them.

### Expose metrics from data plane proxies

To expose metrics from every proxy in the mesh, configure the `Mesh` resource:

{% tabs expose-metrcis useUrlFragment=false %}
{% tab expose-metrcis Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  metrics:
    enabledBackend: prometheus-1
    backends:
    - name: prometheus-1
      type: prometheus
```

which is a shortcut for:

```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  metrics:
    enabledBackend: prometheus-1
    backends:
    - name: prometheus-1
      type: prometheus
      conf:
        skipMTLS: false
        port: 5670
        path: /metrics
        tags: # tags that can be referred in Traffic Permission when metrics are secured by mTLS  
          kuma.io/service: dataplane-metrics
```
{% endtab %}
{% tab expose-metrcis Universal %}

```yaml
type: Mesh
name: default
metrics:
  enabledBackend: prometheus-1
  backends:
  - name: prometheus-1
    type: prometheus
    conf:
      skipMTLS: true # by default mTLS metrics are also protected by mTLS. Scraping metrics with mTLS without transparent proxy is not supported at the moment.
```

which is a shortcut for:

```yaml
type: Mesh
name: default
metrics:
  enabledBackend: prometheus-1
  backends:
  - name: prometheus-1
    type: prometheus
    conf:
      skipMTLS: true
      port: 5670
      path: /metrics
      tags: # tags that can be referred in Traffic Permission when metrics are secured by mTLS  
        kuma.io/service: dataplane-metrics
```
{% endtab %}
{% endtabs %}

This tells Kuma to configure every proxy in the `default` mesh to expose an HTTP endpoint with Prometheus metrics on port `5670` and URI path `/metrics`.

The metrics endpoint is forwarded to the standard Envoy [Prometheus metrics endpoint](https://www.envoyproxy.io/docs/envoy/latest/operations/admin#get--stats?format=prometheus) and supports the same query parameters.
You can pass the `filter` query parameter to limit the results to metrics whose names match a given regular expression.
By default all available metrics are returned.

#### Override Prometheus settings per data plane proxy

{% tabs override-prometheus useUrlFragment=false %}
{% tab override-prometheus Kubernetes %}
To override `Mesh`-wide defaults for a particular `Pod`, use `Kuma`-specific annotations:
* `prometheus.metrics.kuma.io/port` - to override `Mesh`-wide default port
* `prometheus.metrics.kuma.io/path` - to override `Mesh`-wide default path

For example:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: kuma-example
  name: kuma-tcp-echo
spec:
  ...
  template:
    metadata:
      ...
      annotations:
        prometheus.metrics.kuma.io/port: "1234"               # override Mesh-wide default port
        prometheus.metrics.kuma.io/path: "/non-standard-path" # override Mesh-wide default path
    spec:
      containers:
      ...
```

Proxies for this Pod expose an HTTP endpoint with Prometheus metrics on port `1234` and URI path `/non-standard-path`.
{% endtab %}
{% tab override-prometheus Universal %}

To override `Mesh`-wide defaults on a particular machine, configure the `Dataplane` resource:

```yaml
type: Dataplane
mesh: default
name: example
metrics:
  type: prometheus
  conf:
    skipMTLS: true
    port: 1234
    path: /non-standard-path
```

This proxy exposes an HTTP endpoint with Prometheus metrics on port `1234` and URI path `/non-standard-path`.
{% endtab %}
{% endtabs %}

### Configure Prometheus

Although proxy metrics are now exposed, you still need to let Prometheus discover them.

In Prometheus version 2.29 and later, you can add Kuma metrics to your `prometheus.yml`:

```sh
scrape_configs:
    - job_name: 'kuma-dataplanes'
      scrape_interval: "5s"
      relabel_configs:
      - source_labels:
        - __meta_kuma_mesh
        regex: "(.*)"
        target_label: mesh
      - source_labels:
        - __meta_kuma_dataplane
        regex: "(.*)"
        target_label: dataplane
      - source_labels:
        - __meta_kuma_service
        regex: "(.*)"
        target_label: service
      - action: labelmap
        regex: __meta_kuma_label_(.+)
      kuma_sd_configs:
      - server: "http://kuma-control-plane.kuma-system.svc:5676"
```

For more information, see [the Prometheus documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#kuma_sd_config).

For earlier versions of Prometheus, Kuma provides the `kuma-prometheus-sd` tool, which runs alongside your Prometheus instance.
This tool fetches a list of current data plane proxies from the Kuma control plane and saves the list in Prometheus-compatible format 
to a file on disk. Prometheus watches for changes to the file and updates its scraping configuration accordingly.

{% tabs configure-prometheus useUrlFragment=false %}
{% tab configure-prometheus Kubernetes %}

You can run `kumactl install metrics | kubectl apply -f -` to deploy configured Prometheus with Grafana.

If you've already deployed Prometheus, you can use [Prometheus federation](https://prometheus.io/docs/prometheus/latest/federation/) to bring Kuma metrics to your main Prometheus cluster.
{% endtab %}
{% tab configure-prometheus Universal %}
1.  Run `kuma-prometheus-sd`, for example:

    ```shell
    kuma-prometheus-sd run \
      --cp-address=grpcs://kuma-control-plane.internal:5676 \
      --output-file=/var/run/kuma-prometheus-sd/kuma.file_sd.json
    ```

1.  Configure Prometheus to read from the file you just saved. For example, add the following snippet to `prometheus.yml`:

    ```yaml
    scrape_configs:
    - job_name: 'kuma-dataplanes'
      scrape_interval: 15s
      file_sd_configs:
      - files:
        - /var/run/kuma-prometheus-sd/kuma.file_sd.json
    ```

    then run:

    ```shell
    prometheus --config.file=prometheus.yml
    ```

{% endtab %}
{% endtabs %}


Check the Targets page in the Prometheus dashboard. You should see a list of data plane proxies from your mesh. For example:

<center>
<img src="/assets/images/docs/0.4.0/prometheus-targets.png" alt="A screenshot of Targets page on Prometheus UI" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

## Secure data plane proxy metrics

Kuma lets you expose proxy metrics in a secure way by leveraging mTLS. Prometheus needs to be a part of the mesh for this feature to work, which is the default deployment model when `kumactl install metrics` is used on Kubernetes.

{% tabs secure-data-plane useUrlFragment=false %}
{% tab secure-data-plane Kubernetes %}
Make sure that mTLS is enabled in the mesh.
```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  mtls:
    enabledBackend: ca-1
    backends:
    - name: ca-1
      type: builtin
  metrics:
    enabledBackend: prometheus-1
    backends:
    - name: prometheus-1
      type: prometheus
      conf:
        port: 5670
        path: /metrics
        skipMTLS: false
        tags: # tags that can be referred in Traffic Permission  
          kuma.io/service: dataplane-metrics
```

Allow the traffic from Grafana to Prometheus Server and from Prometheus Server to data plane proxy metrics and for other Prometheus components:

```yaml
apiVersion: kuma.io/v1alpha1
kind: TrafficPermission
mesh: default
metadata:
  name: metrics-permissions
spec:
  sources:
    - match:
       kuma.io/service: prometheus-server_kuma-metrics_svc_80
  destinations:
    - match:
       kuma.io/service: dataplane-metrics
    - match:
       kuma.io/service: "prometheus-alertmanager_kuma-metrics_svc_80"
    - match:
       kuma.io/service: "prometheus-kube-state-metrics_kuma-metrics_svc_80"
    - match:
       kuma.io/service: "prometheus-kube-state-metrics_kuma-metrics_svc_81"
    - match:
       kuma.io/service: "prometheus-pushgateway_kuma-metrics_svc_9091"
---
apiVersion: kuma.io/v1alpha1
kind: TrafficPermission
mesh: default
metadata:
  name: grafana-to-prometheus
spec:
   sources:
   - match:
      kuma.io/service: "grafana_kuma-metrics_svc_80"
   destinations:
   - match:
      kuma.io/service: "prometheus-server_kuma-metrics_svc_80"
```

{% endtab %}
{% tab secure-data-plane Universal %}
This feature requires transparent proxy, so it's currently not available for Universal deployments.
{% endtab %}
{% endtabs %}

## Expose metrics from applications

In addition to exposing metrics from the data plane proxies, you might want to expose metrics from applications running next to the proxies.

{% tabs expose-metrics-from-apps useUrlFragment=false %}
{% tab expose-metrics-from-apps Kubernetes %}
Use standard `prometheus.io` annotations on `Pod` or `Service`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: kuma-example
  name: kuma-tcp-echo
spec:
  ...
  template:
    metadata:
      ...
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "1234"
        prometheus.io/path: "/non-standard-path"
    spec:
      containers:
      ...
```
{% endtab %}
{% tab expose-metrics-from-apps Universal %}

Use the Discovery Service of [your choice](https://prometheus.io/docs/prometheus/latest/configuration/configuration/).

{% endtab %}
{% endtabs %}

To consume paths protected by mTLS, you need Traffic Permission that lets Prometheus consume applications.

## Grafana Dashboards

Kuma ships with default dashboards that are available to import from [the Grafana Labs repository](https://grafana.com/orgs/konghq).

### Kuma Dataplane

This dashboard lets you investigate the status of a single dataplane in the mesh.

<center>
<img src="/assets/images/docs/0.4.0/kuma_dp1.jpeg" alt="Kuma Dataplane dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/0.4.0/kuma_dp2.png" alt="Kuma Dataplane dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/0.4.0/kuma_dp3.png" alt="Kuma Dataplane dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/1.1.2/kuma_dp4.png" alt="Kuma Dataplane dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

### Kuma Mesh

This dashboard lets you investigate the aggregated statistics of a single mesh.

<center>
<img src="/assets/images/docs/1.1.2/grafana-dashboard-kuma-mesh.jpg" alt="Kuma Mesh dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

### Kuma Service to Service

This dashboard lets you investigate aggregated statistics from dataplanes of specified source services to dataplanes of specified destination service.

<center>
<img src="/assets/images/docs/0.4.0/kuma_service_to_service.png" alt="Kuma Service to Service dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/1.1.2/kuma_service_to_service_http.png" alt="Kuma Service to Service HTTP" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

### Kuma CP

This dashboard lets you investigate control plane statistics.

<center>
<img src="/assets/images/docs/0.7.1/grafana-dashboard-kuma-cp1.png" alt="Kuma CP dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/0.7.1/grafana-dashboard-kuma-cp2.png" alt="Kuma CP dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/0.7.1/grafana-dashboard-kuma-cp3.png" alt="Kuma CP dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

### Kuma Service

This dashboard lets you investigate aggregated statistics for each service.

<center>
<img src="/assets/images/docs/1.1.2/grafana-dashboard-kuma-service.jpg" alt="Kuma Service dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

### Service Map

This dashboard provides a topology view of your service traffic dependencies. It includes information such as number of requests and error rates.

<center>
<img src="/assets/images/blog/kuma_1_3_0_service_map.png" alt="Kuma Service Map" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

## Grafana Datasource

The Grafana Datasource is a datasource specifically built to relate information from the control-plane with prometheus metrics.

Current features include:

- Display the graph of your services with the MeshGraph using [grafana nodeGraph panel](https://grafana.com/docs/grafana/latest/visualizations/node-graph/).
- List meshes.
- List zones.
- List services.

To use the plugin you'll need to add the binary to your grafana instance by following the [installation instructions](https://github.com/kumahq/kuma-grafana-datasource#how-to-install).

To make things simpler the datasource is installed and configured when using `kumactl install metrics`.
