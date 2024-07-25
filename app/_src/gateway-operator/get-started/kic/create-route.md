---
title: Create a Route
content-type: tutorial
book: kgo-kic-get-started
chapter: 3
---

{% assign gatewayApiVersion = "v1beta1" %}
{% if_version gte:1.1.x %}
{% assign gatewayApiVersion = "v1" %}
{% endif_version %}

{% if_version lte: 1.1.x %}
{:.note}
> **Note:** `Gateway` and `ControlPlane` controllers are still `alpha` so be sure
> to use the [installation steps from this guide](/gateway-operator/{{ page.release }}/get-started/kic/install/)
> in order to get your `Gateway` up and running.
{% endif_version %}

After you've installed all of the required components and configured a `GatewayClass` you can route some traffic to a service in your Kubernetes cluster.

## Configure the echo service

1. In order to route a request using {{ site.base_gateway }} we need a service running in our cluster. Install an `echo` service using the following command:

    ```bash
    kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml
    ```

1.  Create a `HTTPRoute` to send any requests that start with `/echo` to the echo service.

    ```yaml
    echo '
    kind: HTTPRoute
    apiVersion: gateway.networking.k8s.io/{{ gatewayApiVersion }}
    metadata:
      name: echo
    spec:
      parentRefs:
        - group: gateway.networking.k8s.io
          kind: Gateway
          name: kong
      rules:
        - matches:
            - path:
                type: PathPrefix
                value: /echo
          backendRefs:
            - name: echo
              port: 1027
    ' | kubectl apply -f -
    ```
    The results should look like this:

    ```text
    httproute.gateway.networking.k8s.io/echo created
    ```


## Test the configuration

1. To test the configuration, make a call to the `$PROXY_IP` that you configured.

    ```bash
    curl $PROXY_IP/echo
    ```

1. You should see the following:

    ```
    Welcome, you are connected to node king.
    Running on Pod echo-965f7cf84-rm7wq.
    In namespace default.
    With IP address 192.168.194.10.
    ```

   Congratulations! You just configured {{ site.kgo_product_name }}, {{ site.kic_product_name }} and {{ site.base_gateway }} using open standards.

## Next steps

Now that you have a running `DataPlane` configured using Gateway API resources, you can explore the power that {{ site.base_gateway }} provides:

* [Configuring {{ site.base_gateway }} plugins using {{ site.kic_product_name }}](/kubernetes-ingress-controller/latest/guides/using-kongplugin-resource/)
* [Upgrading {{ site.kgo_product_name }} managed data planes](/gateway-operator/{{ page.release }}/guides/upgrade/data-plane/rolling/)
