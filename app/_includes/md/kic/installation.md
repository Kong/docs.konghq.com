## Installation

Please follow the [deployment](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) documentation to install
the {{site.kic_product_name}} onto your Kubernetes cluster.

If you wish to use the Gateway APIs examples, you must first [install the
Gateway API resources](https://gateway-api.sigs.k8s.io/guides/#installing-gateway-api)
and restart your Deployment after:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl rollout restart -n NAMESPACE deployment DEPLOYMENT_NAME
```
{% endnavtab %}
{% navtab Response %}
```text
deployment.apps/DEPLOYMENT_NAME restarted
```
{% endnavtab %}
{% endnavtabs %}

Layer 4 routes (TCPRoute, UDPRoute, TLSRoute) are currently only available in
the Gateway APIs experimental channel. To use them, install the experimental
channel CRDs and enable the corresponding feature gate in
{{site.kic_product_name}}:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl set env -n kong deployment/ingress-kong CONTROLLER_FEATURE_GATES="GatewayAlpha=true" -c ingress-controller
```
{% endnavtab %}
{% navtab Response %}
```text
deployment.apps/ingress-kong env updated
```
{% endnavtab %}
{% endnavtabs %}

If you also use other feature gates, include them as well. The command above
replaces the entire `CONTROLLER_FEATURE_GATES` value.

## Testing connectivity to Kong

This guide assumes that `PROXY_IP` environment variable is
set to contain the IP address or URL pointing to Kong.
If you've not done so, please follow one of the
[deployment guides](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) to configure this environment variable.

If everything is setup correctly, making a request to Kong should return back
a HTTP `404 Not Found` status code.

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -i $PROXY_IP
```
{% endnavtab %}
{% navtab Response %}
```text
HTTP/1.1 404 Not Found
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 48
X-Kong-Response-Latency: 0
Server: kong/3.0.0

{"message":"no Route matched with those values"}
```
{% endnavtab %}
{% endnavtabs %}

This is expected since Kong doesn't know how to proxy the request yet.
