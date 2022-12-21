---
title: Traffic Metrics
---

`Kuma` facilitates consistent traffic metrics across all dataplanes in your mesh.

A user can enable traffic metrics by editing a `Mesh` resource and providing the desired `Mesh`-wide configuration. If necessary, metrics configuration can be customized for each `Dataplane` individually, e.g. to override the default metrics port that might be already in use on that particular machine.

Out-of-the-box, `Kuma` provides full integration with `Prometheus`:
* if enabled, every dataplane will expose its metrics in `Prometheus` format
* furthemore, `Kuma` will make sure that `Prometheus` can automatically find every dataplane in the mesh

To collect metrics from Kuma, you need to first expose metrics from Dataplanes and then configure Prometheus to collect them.

### Expose metrics from Dataplanes

To expose `Prometheus` metrics from every dataplane in the mesh, configure a `Mesh` resource as follows:

{% tabs expose-metrics useUrlFragment=false %}
{% tab expose-metrics Kubernetes %}
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

which is a convenient shortcut for

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
{% tab expose-metrics Universal %}
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

which is a convenient shortcut for

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

Both snippets from above instruct `Kuma` to configure every dataplane in the mesh `default` to expose an HTTP endpoint with `Prometheus` metrics on port `5670` and URI path `/metrics`.

#### Override Prometheus settings per Dataplane

{% tabs override useUrlFragment=false %}
{% tab override Kubernetes %}
To override `Mesh`-wide defaults for a particular `Pod`, use `Kuma`-specific annotations:
* `prometheus.metrics.kuma.io/port` - to override `Mesh`-wide default port
* `prometheus.metrics.kuma.io/path` - to override `Mesh`-wide default path

E.g.,

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

As a result, dataplane for this particular `Pod` will expose an HTTP endpoint with `Prometheus` metrics on port `1234` and URI path `/non-standard-path`.
{% endtab %}
{% tab override Universal %}

To override `Mesh`-wide defaults on a particular machine, configure `Dataplane` resource as follows:

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

As a result, this particular dataplane will expose an HTTP endpoint with `Prometheus` metrics on port `1234` and URI path `/non-standard-path`.
{% endtab %}
{% endtabs %}

### Configure Prometheus

Although dataplane metrics are now exposed, `Prometheus` doesn't know anything about it just yet.

To help `Prometheus` to automatically discover dataplanes, `Kuma` provides a tool - `kuma-prometheus-sd`.
`kuma-prometheus-sd` is meant to run alongside `Prometheus` instance.
It knows location of `Kuma` Control Plane is and can fetch an up-to-date list of dataplanes from it.
It then transforms that information into a format that `Prometheus` can understand, and saves it into a file on disk.
`Prometheus` watches for changes to that file and updates its scraping configuration accordingly.

{% tabs configure useUrlFragment=false %}
{% tab configure Kubernetes %}
Use `kumactl install metrics | kubectl apply -f -` to deploy configured Prometheus with Grafana.

{% tip %}
If you've got Prometheus deployment already, you can use [Prometheus federation](https://prometheus.io/docs/prometheus/latest/federation/) to bring Kuma metrics to your main Prometheus cluster.
{% endtip %}
{% endtab %}

{% tab configure Universal %}
First, you need to run `kuma-prometheus-sd`, e.g. by using the following command:

```shell
kuma-prometheus-sd run \
  --cp-address=grpcs://kuma-control-plane.internal:5676 \
  --output-file=/var/run/kuma-prometheus-sd/kuma.file_sd.json
```

The above configuration tells `kuma-prometheus-sd` to talk to `Kuma` Control Plane at [grpcs://kuma-control-plane.internal:5676](grpcs://kuma-control-plane.internal:5676) and save the list of dataplanes to `/var/run/kuma-prometheus-sd/kuma.file_sd.json`.

Then, you need to set up `Prometheus` to read from that file, e.g. by using `prometheus.yml` config with the following contents:

```yaml
scrape_configs:
- job_name: 'kuma-dataplanes'
  scrape_interval: 15s
  file_sd_configs:
  - files:
    - /var/run/kuma-prometheus-sd/kuma.file_sd.json
```

and running

```shell
prometheus --config.file=prometheus.yml
```
{% endtab %}
{% endtabs %}


Now, if you check `Targets` page on `Prometheus` UI, you should see a list of dataplanes from your mesh, e.g.

<center>
<img src="/assets/images/docs/0.4.0/prometheus-targets.png" alt="A screenshot of Targets page on Prometheus UI" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

## Secure Dataplane metrics

Kuma lets you expose Dataplane metrics in a secure way by leveraging mTLS. Prometheus needs to be a part of the Mesh for this feature to work, which is the default deployment model when `kumactl install metrics` is used on Kubernetes.

{% tabs secure-metrics useUrlFragment=false %}
{% tab secure-metrics Kubernetes %}
Make sure that mTLS is enabled in the Mesh.
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

Allow the traffic from Grafana to Prometheus Server and from Prometheus Server to Dataplane metrics and for other Prometheus components:

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
{% tab secure-metrics Universal %}
This feature requires transparent proxy, therefore for now it's not available in Universal for now.
{% endtab %}
{% endtabs %}

## Expose metrics from applications

In addition to exposing metrics from Dataplane, you may want to expose metrics from application next to Kuma DP.

{% tabs expose-metrics-from-apps useUrlFragment=false %}
{% tab expose-metrics-from-apps Kubernetes %}
Use standard `prometheus.io` annotations either on `Pod` or `Service`
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
Use Discovery Service of [your choice](https://prometheus.io/docs/prometheus/latest/configuration/configuration/).
In the future Kuma will help to expose metrics in more native way.
{% endtab %}
{% endtabs %}

Remember that in order to consume paths protected by mTLS, you need Traffic Permission that lets Prometheus consume applications.

## Grafana Dashboards

Kuma ships with 4 default dashboards that are available to import from [Grafana Labs repository](https://grafana.com/orgs/konghq).

### Kuma Dataplane

This dashboards lets you investigate the status of a single dataplane in the mesh.

<center>
<img src="/assets/images/docs/0.4.0/kuma_dp1.jpeg" alt="Kuma Dataplane dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/0.4.0/kuma_dp2.png" alt="Kuma Dataplane dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/0.4.0/kuma_dp3.png" alt="Kuma Dataplane dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/1.1.6/kuma_dp4.png" alt="Kuma Dataplane dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

### Kuma Mesh

This dashboard lets you investigate the aggregated statistics of a single mesh.

<center>
<img src="/assets/images/docs/1.1.6/grafana-dashboard-kuma-mesh.jpg" alt="Kuma Mesh dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

### Kuma Service to Service

This dashboard lets you investigate aggregated statistics from dataplanes of given source service to dataplanes of given destination service.

<center>
<img src="/assets/images/docs/0.4.0/kuma_service_to_service.png" alt="Kuma Service to Service dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/1.1.6/kuma_service_to_service_http.png" alt="Kuma Service to Service HTTP" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

### Kuma CP

This dashboard lets you investigate statistics of the control plane.

<center>
<img src="/assets/images/docs/0.7.1/grafana-dashboard-kuma-cp1.png" alt="Kuma CP dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/0.7.1/grafana-dashboard-kuma-cp2.png" alt="Kuma CP dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/0.7.1/grafana-dashboard-kuma-cp3.png" alt="Kuma CP dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

### Kuma Service

This dashboard lets you investigate aggregated statistics for each service.

<center>
<img src="/assets/images/docs/1.1.6/grafana-dashboard-kuma-service.jpg" alt="Kuma Service dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>
