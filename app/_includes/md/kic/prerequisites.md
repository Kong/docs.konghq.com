<details markdown="1">
<summary>
<blockquote class="note">
  <p style="cursor: pointer">Before you begin ensure that you have <u>Installed {{site.kic_product_name}} </u> in your Kubernetes cluster and are able to connect to Kong.</p>
</blockquote>
</summary>

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

1. Install {{site.kic_product_name}} and {{ site.base_gateway }} with Helm:

    ```bash
    helm install kong kong/ingress -n kong --create-namespace
    ```

### Test connectivity to Kong

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

    If you are not able to connect to Kong, read the [deployment guide](/kubernetes-ingress-controller/{{ page.release }}/deployment/overview/).

</details>
