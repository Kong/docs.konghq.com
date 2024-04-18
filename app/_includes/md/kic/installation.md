
## Installation

Follow the [deployment](/kubernetes-ingress-controller/{{page.release}}/deployment/overview/) documentation to install the {{site.kic_product_name}} on the Kubernetes cluster.

{% unless include.disable_gateway_api %}
## Installing the Gateway APIs

If you wish to use the Gateway APIs examples, follow the [supplemental
Gateway APIs installation instructions](/kubernetes-ingress-controller/{{page.release}}/deployment/install-gateway-apis).
{% endunless %}

## Testing connectivity to {{site.base_gateway}}

Ensure that the `PROXY_IP` environment variable is
set to contain the IP address or URL pointing to {{site.base_gateway}}.
The [deployment guide](/kubernetes-ingress-controller/{{page.release}}/deployment/overview) that you used to install the {{site.kic_product_name}} on the Kubernetes cluster provides the instructions to configure this environment variable.

If everything is set correctly, a request to {{site.base_gateway}} returns
a HTTP `404 Not Found` status code:

```bash
curl -i $PROXY_IP
```
The results should look like this:
```text
HTTP/1.1 404 Not Found
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 48
X-Kong-Response-Latency: 0
Server: kong/3.0.0

{"message":"no Route matched with those values"}
```

This is expected because {{site.base_gateway}} doesn't know how to proxy the request yet.


