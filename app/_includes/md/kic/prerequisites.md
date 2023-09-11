<details markdown="1">
<summary>
<blockquote class="note">
  <p style="cursor: pointer">This guide assumes that you have installed {{site.kic_product_name}} in your Kubernetes cluster.<br /><u>Click here</u> to show installation instructions</p>
</blockquote>
</summary>

## Prerequisites

Before following this guide, you will need to install and configure {{site.kic_product_name}}.

{% unless include.disable_gateway_api %}
## Installing the Gateway APIs

If you wish to use the Gateway APIs examples, ensure that you enable support for [
Gateway APIs in KIC](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/install-gateway-apis).
{% endunless %}


### Install Kong

1. Add the Kong Helm charts:

    ```bash
    helm repo add kong https://charts.konghq.com
    helm repo update
    ```

2. Install {{site.kic_product_name}} and {{ site.base_gateway }} with Helm:

    ```bash
    helm install kong kong/ingress -n kong --create-namespace
    ```

### Testing connectivity to Kong

Kubernetes exposes the proxy through a Kubernetes service. Run the following commands to store the load balancer IP address in a variable named `PROXY_IP`:

1. Populate `$PROXY_IP` for future commands:

    ```bash
    export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-gateway-proxy)
    
    echo "Proxy IP: $PROXY_IP"
    ```

2. Ensure that you can call the proxy IP:

    ```bash
    curl -i $PROXY_IP
    ```

    The result should look like this:

    ```bash
    HTTP/1.1 404 Not Found
    Content-Type: application/json; charset=utf-8
    Connection: keep-alive
    Content-Length: 48
    X-Kong-Response-Latency: 0
    Server: kong/3.0.0
  
    {"message":"no Route matched with those values"}
    ```

    If the above instructions do not work for you, please read our more [detailed deployment guides](/kubernetes-ingress-controller/{{ page.release }}/deployment/overview/).

</details>