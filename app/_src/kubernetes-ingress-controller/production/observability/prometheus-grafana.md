---
title: Using Prometheus and Grafana
type: explanation
purpose: |
  How to install Prometheus and Grafana with KIC
---

The {{site.kic_product_name}} gives you visibility into how {{site.base_gateway}} is performing and how the services in your Kubernetes cluster are responding to the inbound traffic.

Learn to set up monitoring for {{site.base_gateway}} with Prometheus.

As of {{site.kic_product_name}} 2.0, there are additional
performance metrics associated with the configuration process
rather than the runtime performance of the Gateway. For more information, see the [Prometheus metrics reference](/kubernetes-ingress-controller/{{page.kong_version}}/production/observability/prometheus/).

{% include /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=true %}

## Install Prometheus and Grafana

If you already have the [Prometheus
Operator](https://github.com/prometheus-operator/prometheus-operator) and
Grafana installed in your cluster, you can skip installing Prometheus and Grafana.

{:.note}
> **Note:** The Prometheus Operator is required, as the {{site.kic_product_name}}
uses its PodMonitor custom resource to configure scrape rules.

Install Prometheus with a scrape interval of 10 seconds to have fine-grained data points for all metrics. And install both Prometheus and Grafana in a dedicated `monitoring` namespace.

1. Create a `values-monitoring.yaml` file to set the scrape interval, use Grafana
persistence, and install Kong's dashboard:
    ```yaml
    prometheus:
      prometheusSpec:
        scrapeInterval: 10s
        evaluationInterval: 30s
    grafana:
      persistence:
        enabled: true  # enable persistence using Persistent Volumes
      dashboardProviders:
        dashboardproviders.yaml:
          apiVersion: 1
          providers:
          - name: 'default' # Configure a dashboard provider file to
            orgId: 1        # put Kong dashboard into.
            folder: ''
            type: file
            disableDeletion: false
            editable: true
            options:
              path: /var/lib/grafana/dashboards/default
      dashboards:
        default:
          kong-dash:
            gnetId: 7424  # Install the following Grafana dashboard in the
            revision: 11  # instance: https://grafana.com/dashboards/7424
            datasource: Prometheus
          kic-dash:
            gnetId: 15662
            datasource: Prometheus
    
    ```

1. To install Prometheus and Grafana, execute the following, specifying the path to the `values-monitoring.yaml` file that you created:

    ```bash
    $ kubectl create namespace monitoring
    $ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    $ helm install promstack prometheus-community/kube-prometheus-stack --namespace monitoring --version 52.1.0 -f values-monitoring.yaml
    ```

## Enable ServiceMonitor

1. To enable ServiceMonitor, set `gateway.serviceMonitor.enabled=true`.

    ```bash
    $ helm upgrade kong kong/ingress -n kong --set gateway.serviceMonitor.enabled=true --set gateway.serviceMonitor.labels.release=promstack
    ```

    By default, kube-prometheus-stack [selects ServiceMonitors and PodMonitors by a`release` label equal to the release name](https://github.com/prometheus-community/helm-charts/blob/kube-prometheus-stack-19.0.1/charts/kube-prometheus-stack/values.yaml#L2128-L2169). The `labels` setting here adds a label matching the `promstack` release name from the example.

1. Enable the Prometheus plugin in Kong at the global level, so that each request that flows into the Kubernetes cluster gets tracked in Prometheus:

    ```bash
    $ echo 'apiVersion: configuration.konghq.com/v1
    kind: KongClusterPlugin
    metadata:
      name: prometheus
      annotations:
        kubernetes.io/ingress.class: kong
      labels:
        global: "true"
    plugin: prometheus
    config:
      status_code_metrics: true
      bandwidth_metrics: true
      upstream_health_metrics: true
      latency_metrics: true
      per_consumer: false
    ' | kubectl apply -f -
    ```

    The results should look like this:
    ```text
    kongclusterplugin.configuration.konghq.com/prometheus created
    ```

## Set Up Port Forwards

In a production environment, you would have a Kubernetes Service with
an external IP or load balancer, which would allow you to access
Prometheus, Grafana, and Kong.
For demo purposes, set up port-forwarding using kubectl to get access.
It is not advisable to do this in production.

Open a new terminal and execute these commands:

```bash
kubectl -n monitoring port-forward services/prometheus-operated 9090 &
kubectl -n monitoring port-forward services/promstack-grafana 3000:80 &

# You can access Prometheus in your browser at localhost:9090
# You can access Grafana in your browser at localhost:3000
# You can access Kong at $PROXY_IP
# We are using plain-text HTTP proxy for this purpose of
# demo.
```

## Access Grafana Dashboard

To access Grafana, you need to get the password for the admin user.

Execute the following to read the password and take note of it:

```bash
kubectl get secret --namespace monitoring promstack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

Now, browse to [http://localhost:3000](http://localhost:3000) and
fill in username as “admin” and password that you made a note of.
After you log in to Grafana you can notice that Kong’s Grafana Dashboard should already be installed for you.

## Setup Services

Spin up some services for demo purposes and setup Ingress
routing for them.

1. Install three services: billing, invoice, and comments.

    ```bash
    kubectl apply -f {{ site.links.web }}/assets/kubernetes-ingress-controller/examples/multiple-services.yaml
    ```

1. Create Ingress routing rules in Kubernetes. This configures Kong to proxy traffic destined for these services correctly.

    ```bash
    echo '
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: sample-ingresses
      annotations:
        konghq.com/strip-path: "true"
    spec:
      ingressClassName: kong
      rules:
      - http:
         paths:
         - path: /billing
           pathType: ImplementationSpecific
           backend:
             service:
               name: billing
               port:
                 number: 80
         - path: /comments
           pathType: ImplementationSpecific
           backend:
             service:
               name: comments
               port:
                 number: 80
         - path: /invoice
           pathType: ImplementationSpecific
           backend:
             service:
               name: invoice
               port:
                 number: 80
    ' | kubectl apply -f -
    ```

1. Create some traffic after configuring the services and proxies.

    ```bash
    while true;
    do
      curl $PROXY_IP/billing/status/200
      curl $PROXY_IP/billing/status/501
      curl $PROXY_IP/invoice/status/201
      curl $PROXY_IP/invoice/status/404
      curl $PROXY_IP/comments/status/200
      curl $PROXY_IP/comments/status/200
      sleep 0.01
    done
    ```

Because you have already enabled Prometheus plugin in Kong to
collect metrics for requests proxied via Kong, you should see metrics coming through in the Grafana dashboard.

You should be able to see metrics related to the traffic flowing
through the services.
Try tweaking the above script to send different traffic patterns
and see how the metrics change.
The upstream services are httpbin instances, meaning you can use
a variety of endpoints to shape your traffic.

## Metrics collected

### Request Latencies of Various Services

![Request latencies](/assets/images/products/kubernetes-ingress-controller/request-latencies.png)

Kong collects latency data of how long your services take to respond to
requests. One can use this data to alert the on-call engineer if the latency
goes beyond a certain threshold. For example, let’s say you have an SLA
that your APIs will respond with latency of less than 20 millisecond
for 95% of the requests.
You could configure Prometheus to alert based on the following query:

```text
histogram_quantile(0.95, sum(rate(kong_request_latency_ms_sum{route=~"$route"}[1m])) by (le)) > 20
```

The query calculates the 95th percentile of the total request
latency (or duration) for all of your services and alerts you if it is more
than 20 milliseconds.
The “type” label in this query is “request”, which tracks the latency
added by Kong and the service.
You can switch this to “upstream” to track latency added by the service only.
Prometheus is highly flexible and well documented, so we won’t go into
details of setting up alerts here, but you’ll be able to find them
in the Prometheus documentation.

### Kong Proxy Latency

![Proxy latencies](/assets/images/products/kubernetes-ingress-controller/proxy-latencies.png)

Kong also collects metrics about its performance.
The following query is similar to the previous one but gives
us insight into latency added by Kong:

```text
histogram_quantile(0.90, sum(rate(kong_kong_latency_ms_bucket[1m])) by (le,service)) > 2
```

### Error Rates

![Error rates](/assets/images/products/kubernetes-ingress-controller/error-rates.png)

Another important metric to track is the rate of errors and requests
your services are serving.
The time series `kong_http_status` collects HTTP status code metrics
for each service.

This metric can help you track the rate of errors for each of your service:

```text
sum(rate(kong_http_requests_total{code=~"5[0-9]{2}"}[1m])) by (service)
```

You can also calculate the percentage of requests in any duration
that are errors. Try to come up with a query to derive that result.

Please note that all HTTP status codes are indexed, meaning you could use
the data to learn about your typical traffic pattern and identify problems.
For example, a sudden rise in 404 response codes could be indicative
of client codes requesting an endpoint that was removed in a recent deploy.

### Request Rate and Bandwidth

![Request rates](/assets/images/products/kubernetes-ingress-controller/request-rate.png)

One can derive the total request rate for each of your services or
across your Kubernetes cluster using the `kong_http_status` time series.

![Bandwidth](/assets/images/products/kubernetes-ingress-controller/bandwidth.png)

Another metric that Kong keeps track of is the amount of
network bandwidth (`kong_bandwidth`) being consumed.
This gives you an estimate of how request/response sizes
correlate with other behaviors in your infrastructure.

You now have metrics for the services running inside your Kubernetes cluster
and have much more visibility into your applications, without making
any modifications in your services.
You can use Alertmanager or Grafana to now configure alerts based on
the metrics observed and your SLOs.