---
title: Deploying Sidecars
---

{% assign gatewayConfigApiVersion = "v1beta1" %}
{% if_version lte:1.1.x %}
{% assign gatewayConfigApiVersion = "v1alpha1" %}
{% endif_version %}

{{ site.kgo_product_name }} uses [PodTemplateSpec](/gateway-operator/{{ page.release }}/customization/pod-template-spec/) to customize deployments.

Here is an example that deploys a [Vector](https://vector.dev/) sidecar alongside the proxy containers.

## Configure vector.dev

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: sidecar-vector-config
data:
  vector.toml: |
    [sources.proxy_access_log_source]
    type = "file"
    include = [ "/etc/kong/log/proxy_access.log" ]
    [sinks.proxy_access_log_sink]
    type = "console"
    inputs = [ "proxy_access_log_source" ]
    encoding.codec = "json"
```

## Configure PodTemplateSpec

{% kgo_podtemplatespec_example %}
gatewayConfigApiVersion: {{ gatewayConfigApiVersion }}
dataplane:
  metadata:
    labels:
      dataplane-pod-label: example
    annotations:
      dataplane-pod-annotation: example
  spec:
    volumes:
    - name: cluster-certificate
    - name: sidecar-vector-config-volume
      configMap:
        name: sidecar-vector-config
    - name: proxy-logs
      emptyDir:
        sizeLimit: 128Mi
    containers:
    - name: sidecar
      image: timberio/vector:0.31.0-debian
      volumeMounts:
      - name: sidecar-vector-config-volume
        mountPath: /etc/vector
      - name: proxy-logs
        mountPath: /etc/kong/log/
      readinessProbe:
        initialDelaySeconds: 1
        periodSeconds: 1
    - name: proxy
      image: kong:3.4
      volumeMounts:
      - name: proxy-logs
        mountPath: /etc/kong/log/
      env:
      - name: KONG_LOG_LEVEL
        value: debug
      - name: KONG_PROXY_ACCESS_LOG
        value: /etc/kong/log/proxy_access.log
      resources:
        requests:
          memory: "64Mi"
          cpu: "250m"
        limits:
          memory: "1024Mi"
          cpu: "1000m"
      readinessProbe:
        initialDelaySeconds: 1
        periodSeconds: 1
{% endkgo_podtemplatespec_example %}