---
title: Observability
---

This page will describe how to configure different observability tools to work with {{site.mesh_product_name}}.

## Demo setup

`kumactl` ships with a builtin observability stack which consists of:

- [prometheus](https://prometheus.io) for metrics
- [jaeger](https://jaegertracing.io) for ingesting and storing traces
- [loki](https://grafana.com/oss/loki/) for ingesting and storing logs
- [grafana](https://grafana.com/oss/grafana/) for querying and displaying metrics, traces and logs

First, remember to configure {{site.mesh_product_name}} appropriately for the tools in the observability stack:

- [Traffic metrics](/docs/{{ page.version }}/policies/traffic-metrics) for telemetry
- [`TrafficTrace`](/docs/{{ page.version }}/policies/traffic-trace) for tracing
- [`TrafficLog`](/docs/{{ page.version }}/policies/traffic-log) for logging

On Kubernetes, the stack can be installed with:

```shell
kumactl install observability | kubectl apply -f -
```

This will create a namespace `mesh-observability` with prometheus, jaeger, loki and grafana installed and setup to work with {{site.mesh_product_name}}.

{% warning %}
This setup is meant to be used for trying out {{site.mesh_product_name}}. It is in no way fit for use in production.
For production setups we recommend referring to each project's website or to use a hosted solution like Grafana cloud or Datadog.
{% endwarning %}

## Control plane metrics

Control plane metrics are exposed on port `:5680` and available under the standard path `/metrics`.

## Configuring Prometheus

The {{site.mesh_product_name}} community has contributed a builtin service discovery to Prometheus, it is documented in the [Prometheus docs](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#kuma_sd_config).
This service discovery will connect to the control plane and retrieve all data planes with enabled metrics which Prometheus will scrape and retrieve metrics according to your [traffic metrics setup](/docs/{{ page.version }}/policies/traffic-metrics).

{% tip %}
There are 2 ways you can run prometheus:

1. Inside the mesh (default for [`kumactl install observability`](#demo-setup)). In this case you can use mTLS to retrieve the metrics. This provides high security but will require one prometheus per mesh and might not be accessible if your mesh becomes unavailable. It will also require one Prometheus deployment per {{site.mesh_product_name}} mesh.
2. Outside the mesh. In this case you'll need to specify `skipMTLS: true` in the [traffic metrics configuration](/docs/{{ page.version }}/policies/traffic-metrics). This is less secured but will ensure Prometheus is as available as possible. It is also easier to add to an existing setup with services in and outside the mesh.

In production, we recommend the second option as it provides better visibility when things go wrong, and it's usually acceptable for metrics to be less secure.
{% endtip %}

### Using an already existing prometheus setup

In Prometheus version 2.29 and later, you can add {{site.mesh_product_name}} metrics to your `prometheus.yml`:

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
      - server: "http://kuma-control-plane.{{site.default_namespace}}.svc:5676" # replace with the url of your control plane
```

For more information, see [the Prometheus documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#kuma_sd_config).

If you have [traffic metrics](/docs/{{ page.version }}/policies/traffic-metrics) enabled for your mesh, check the Targets page in the Prometheus dashboard.
You should see a list of data plane proxies from your mesh. For example:

<center>
<img src="/assets/images/docs/0.4.0/prometheus-targets.png" alt="A screenshot of Targets page on Prometheus UI" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

## Configuring Grafana

#### Visualizing traces

To visualise your **traces** you need to have Grafana up and running.

{% tip %}
[`kumactl install observability`](#demo-setup) sets this up out of the box.
{% endtip %}

With Grafana installed you can configure a new datasource with url:`http://jaeger-query.mesh-observability/` (or whatever url jaeger can be queried at).
Grafana will then be able to retrieve the traces from Jaeger.

<center>
<img src="/assets/images/docs/jaeger_grafana_config.jpg" alt="Jaeger Grafana configuration" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

You can then add a [TrafficTrace policy](/docs/{{ page.version }}/policies/traffic-trace) to your mesh to start emitting traces.
At this point you can visualize your traces in Grafana by choosing the jaeger datasource in the [explore section](https://grafana.com/docs/grafana/latest/explore/).

#### Visualizing logs

To visualise your **containers' logs** and your **access logs** you need to have a Grafana up and running.

{% tip %}
[`kumactl install observability`](#demo-setup) sets this up out of the box.
{% endtip %}

<center>
<img src="/assets/images/docs/loki_grafana_config.jpg" alt="Loki Grafana configuration" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

You can then add a [TrafficLog policy](/docs/{{ page.version }}/policies/traffic-log) to your mesh to start emitting access logs. Loki will pick up logs that are sent to `stdout`. To send logs to `stdout` you can configure the logging backend as shown below:

{% tabs visualizing-logs useUrlFragment=false %}
{% tab visualizing-logs Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  logging:
    defaultBackend: stdout
    backends:
      - name: stdout
        type: file
        conf:
          path: /dev/stdout
```

{% endtab %}
{% tab visualizing-logs Universal %}
```yaml
type: Mesh
name: default
logging:
  defaultBackend: stdout
  backends:
    - name: stdout
      type: file
      conf:
        path: /dev/stdout
```
{% endtab %}
{% endtabs %}

At this point you can visualize your **containers' logs** and your **access logs** in Grafana by choosing the loki datasource in the [explore section](https://grafana.com/docs/grafana/latest/explore/).

For example, running: `{container="kuma-sidecar"} |= "GET"` will show all GET requests on your cluster.
To learn more about the search syntax check the [Loki docs](https://grafana.com/docs/loki/latest/logql/).

{% tip %}
**Nice to have**

Having your Logs and Traces in the same visualisation tool can come really handy. By adding the `traceId` in your app logs you can visualize your logs and the related Jaeger traces.
To learn more about it go read [this article](https://grafana.com/blog/2020/05/22/new-in-grafana-7.0-trace-viewer-and-integrations-with-jaeger-and-zipkin/).
{% endtip %}

### Grafana extensions

The {{site.mesh_product_name}} community has built a datasource and a set of dashboards to provide great interactions between {{site.mesh_product_name}} and Grafana.

#### Datasource and service map

The Grafana Datasource is a datasource specifically built to relate information from the control plane with Prometheus metrics.

Current features include:

- Display the graph of your services with the MeshGraph using [Grafana nodeGraph panel](https://grafana.com/docs/grafana/latest/visualizations/node-graph/).
- List meshes.
- List zones.
- List services.

To use the plugin you'll need to add the binary to your Grafana instance by following the [installation instructions](https://github.com/kumahq/kuma-grafana-datasource).

To make things simpler the datasource is installed and configured when using [`kumactl install observability`](#demo-setup).

#### Dashboards

{{site.mesh_product_name}} ships with default dashboards that are available to import from [the Grafana Labs repository](https://grafana.com/orgs/konghq).

##### {{site.mesh_product_name}} Dataplane

This dashboard lets you investigate the status of a single dataplane in the mesh. In order to see those metrics, you need to create [Traffic Metrics policy](/docs/{{ page.version }}/policies/traffic-metrics/) first. 

<center>
<img src="/assets/images/docs/0.4.0/kuma_dp1.jpeg" alt="Kuma Dataplane dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/0.4.0/kuma_dp2.png" alt="Kuma Dataplane dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/0.4.0/kuma_dp3.png" alt="Kuma Dataplane dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/1.1.2/kuma_dp4.png" alt="Kuma Dataplane dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

##### {{site.mesh_product_name}} Mesh

This dashboard lets you investigate the aggregated statistics of a single mesh.
It provides a topology view of your service traffic dependencies (**Service Map**)
and includes information such as number of requests and error rates.

<center>
<img src="/assets/images/docs/grafana_dashboard_mesh.png" alt="Kuma Mesh dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

##### {{site.mesh_product_name}} Service to Service

This dashboard lets you investigate aggregated statistics from dataplanes of specified source services to dataplanes of specified destination service.

<center>
<img src="/assets/images/docs/0.4.0/kuma_service_to_service.png" alt="Kuma Service to Service dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/1.1.2/kuma_service_to_service_http.png" alt="Kuma Service to Service HTTP" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

##### {{site.mesh_product_name}} CP

This dashboard lets you investigate control plane statistics.

<center>
<img src="/assets/images/docs/0.7.1/grafana-dashboard-kuma-cp1.png" alt="Kuma CP dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/0.7.1/grafana-dashboard-kuma-cp2.png" alt="Kuma CP dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
<img src="/assets/images/docs/0.7.1/grafana-dashboard-kuma-cp3.png" alt="Kuma CP dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

##### {{site.mesh_product_name}} Service

This dashboard lets you investigate aggregated statistics for each service.

<center>
<img src="/assets/images/docs/1.1.2/grafana-dashboard-kuma-service.jpg" alt="Kuma Service dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

##### {{site.mesh_product_name}} MeshGateway

This dashboard lets you investigate aggregated statistics for each builtin gateway.

<center>
<img src="/assets/images/docs/grafana_dashboard_gateway.png" alt="Kuma Gateway dashboard" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>


## Configuring Datadog

The recommended way to use Datadog is with its [agent](https://docs.datadoghq.com/agent).


{% tabs datadog useUrlFragment=false %}
{% tab datadog Kubernetes %}
The [Datadog agent docs](https://docs.datadoghq.com/agent/kubernetes/installation) have in-depth installation methods.
{% endtab %}

{% tab datadog Universal %}
Checkout the [Datadog agent docs](https://docs.datadoghq.com/agent/basic_agent_usage).
{% endtab %}
{% endtabs %}


### Metrics

{{site.mesh_product_name}} exposes metrics with [traffic metrics](/docs/{{ page.version }}/policies/traffic-metrics) in Prometheus format.

You can add annotations to your pods to enable the Datadog agent to scrape metrics.

{% tabs metrics useUrlFragment=false %}
{% tab metrics Kubernetes %}
Please refer to the dedicated [documentation](https://docs.datadoghq.com/containers/kubernetes/prometheus/?tabs=helm#metric-collection-with-prometheus-annotations).
{% endtab %}

{% tab metrics Universal %}
You need to setup your agent with an [openmetrics.d/conf.yaml](https://docs.datadoghq.com/integrations/guide/prometheus-host-collection/#pagetitle).
{% endtab %}
{% endtabs %}

### Tracing

Checkout the
1. Set up the [Datadog](https://docs.datadoghq.com/tracing/) agent.
2. Set up [APM](https://docs.datadoghq.com/tracing/).

{% tabs tracing useUrlFragment=false %}
{% tab tracing Kubernetes %}
Configure the [Datadog agent for APM](https://docs.datadoghq.com/agent/kubernetes/apm/).

If Datadog is not running on each node you can expose the APM agent port to {{site.mesh_product_name}} via Kubernetes service.
```yaml
apiVersion: v1
kind: Service
metadata:
  name: trace-svc
spec:
  selector:
    app.kubernetes.io/name: datadog-agent-deployment
  ports:
    - protocol: TCP
      port: 8126
      targetPort: 8126
```

Apply the configuration with `kubectl apply -f [..]`.

Check if the label of the datadog pod installed has not changed (`app.kubernetes.io/name: datadog-agent-deployment`),
if it did adjust accordingly.
{% endtab %}

{% tab tracing Universal %}
Checkout the [Datadog agent docs](https://docs.datadoghq.com/agent/basic_agent_usage)
{% endtab %}
{% endtabs %}

Once the agent is configured to ingest traces you'll need to configure a [TrafficTrace](/docs/{{ page.version }}/policies/traffic-trace).

### Logs

The best way to have {{site.mesh_product_name}} and Datadog work together is with [TCP ingest](https://docs.datadoghq.com/agent/logs/?tab=tcpudp#custom-log-collection).

Once your agent is configured with TCP ingest you can configure a [TrafficLog](/docs/{{ page.version }}/policies/traffic-log) for data plane proxies to send logs.

## Observability in multi-zone

{{site.mesh_product_name}} is multi-zone at heart. We explain here how to architect your telemetry stack to accommodate multi-zone.

### Prometheus

When {{site.mesh_product_name}} is used in multi-zone the recommended approach is to use 1 Prometheus instance in each zone and to send the metrics of each zone to a global Prometheus instance.

Prometheus offers different ways to do this:

- [Federation](https://prometheus.io/docs/prometheus/latest/federation/) the global Prometheus will scrape each zone Prometheuses.
- [Remote Write](https://prometheus.io/docs/prometheus/latest/storage/#remote-storage-integrations) each zone Prometheuses will directly write their metrics to the global, this is meant to be more efficient the API the federation.
- [Remote Read](https://prometheus.io/docs/prometheus/latest/storage/#remote-storage-integrations) like remote write but the other way around.

### Jaeger, Loki, Datadog and others

Most telemetry components don't have a hierarchical setup like Prometheus.
If you want to have a central view of everything you can set up the system in global and have each zone send their data to it.
Because zone is present in data plane tags you shouldn't be worried about metrics, logs and traces overlapping between zones.
