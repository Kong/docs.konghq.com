<details markdown="1">
<summary>
<blockquote class="note">
  <p style="cursor: pointer">Before you begin ensure that you have <u>Installed {{site.kic_product_name}} </u> in your Kubernetes cluster and are able to connect to Kong. {% if include.enterprise %}This guide requires <strong>Kong Enterprise</strong>.{% endif %}</p>
</blockquote>
</summary>

{% unless include.disable_gateway_api %}
## Install the Gateway APIs

If you wish to use the Gateway APIs examples, ensure that you enable support for [
Gateway APIs in KIC](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/install-gateway-apis).
{% endunless %}

## Prerequisites

### Install Kong
You can install Kong in your Kubernetes cluster using [Helm](https://helm.sh/).
1. Add the Kong Helm charts:

    ```bash
    helm repo add kong https://charts.konghq.com
    helm repo update
    ```

{% if include.enterprise %}
1. Create a file named `license.json` containing your Kong Enterprise license and store it in a Kubenetes secret:

    ```bash
    kubectl create namespace kong
    kubectl create secret generic kong-enterprise-license --from-file=license=./license.json -n kong
    ```

1. Create a `values.yaml` file:

    ```yaml
    gateway:
      image:
        repository: kong/kong-gateway
      env:
        LICENSE_DATA:
          valueFrom:
            secretKeyRef:
              name: kong-enterprise-license
              key: license
    ```
{% endif %}

1. Install {{site.kic_product_name}} and {{ site.base_gateway }} with Helm:

    ```bash
    helm install kong kong/ingress -n kong --create-namespace {% if include.enterprise %}--values ./values.yaml{% endif %}
    ```

### Test connectivity to Kong

Kubernetes exposes the proxy through a Kubernetes service. Run the following commands to store the load balancer IP address in a variable named `PROXY_IP`:

1. Populate `$PROXY_IP` for future commands:

    ```bash
    HOST=$(kubectl get svc --namespace kong kong-gateway-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    export PROXY_IP=${HOST}
    echo $PROXY_IP
    ```

2. Ensure that you can call the proxy IP:

    ```bash
    curl -i $PROXY_IP
    ```

    The results should look like this:

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
