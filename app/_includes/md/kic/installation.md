## Installation

Please follow the [deployment](/kong-ingress-controller/{{page.kong_version}}/deployment/overview/) documentation to install
the {{site.kic_product_name}} onto your Kubernetes cluster.

## Installing the Gateway APIs

If you wish to use the Gateway APIs examples, follow the [supplemental
Gateway APIs installation instructions](/kong-ingress-controller/{{page.kong_version}}/deployment/install-gateway-apis).

## Testing connectivity to {{site.base_gateway}}

This guide assumes that `PROXY_IP` environment variable is
set to contain the IP address or URL pointing to {{site.base_gateway}}.
If you've not done so, follow one of the
[deployment guides](/kong-ingress-controller/{{page.kong_version}}/deployment/overview) to configure this environment variable.

If everything is setup correctly, making a request to {{site.base_gateway}} should return back
a HTTP `404 Not Found` status code:

```bash
curl -i $PROXY_IP
```
Response:
```text
HTTP/1.1 404 Not Found
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 48
X-Kong-Response-Latency: 0
Server: kong/3.0.0

{"message":"no Route matched with those values"}
```

This is expected since {{site.base_gateway}} doesn't know how to proxy the request yet.
