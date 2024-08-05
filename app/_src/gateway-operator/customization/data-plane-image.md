---
title: Customizing the Data Plane image
---

{% assign gatewayConfigApiVersion = "v1beta1" %}
{% if_version lte:1.1.x %}
{% assign gatewayConfigApiVersion = "v1alpha1" %}
{% endif_version %}

You can customize the image of your `DataPlane` using the `DataPlane` resource or the `GatewayConfiguration` CRD .

{% kgo_podtemplatespec_example %}
release: {{ page.release }}
gatewayConfigApiVersion: {{ gatewayConfigApiVersion }}
dataplane:
  spec:
    containers:
    - name: proxy
      image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
controlplane:
  spec:
    containers:
    - name: controller
      image: kong/kubernetes-ingress-controller:{{ site.data.kong_latest_KIC.version }}
{% endkgo_podtemplatespec_example %}
