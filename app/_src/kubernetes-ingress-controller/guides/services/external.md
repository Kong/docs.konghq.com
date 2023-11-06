---
title: External Service
type: how-to
purpose: |
  How to proxy traffic to an external service
---

Expose a service located outside the Kubernetes cluster using an Ingress.

{% include /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false %}

## Create a Kubernetes Service

1. Deploy a Kubernetes Service [type=ExternalName][0] using the hostname of the application you want to expose.

    ```bash
    echo "
    kind: Service
    apiVersion: v1
    metadata:
      name: proxy-to-httpbin
    spec:
      ports:
      - protocol: TCP
        port: 80
      type: ExternalName
      externalName: httpbin.org
    " | kubectl apply -f -
    ```
    The results should look like this:
    ```
    service/proxy-to-httpbin created
    ```    
1. Create an Ingress to expose the service at the path `/httpbin`

    {% include /md/kic/http-test-routing-resource.md kong_version=page.kong_version path='/httpbin' name='proxy-from-k8s-to-httpbin' service='proxy-to-httpbin' port='80' skip_host=true %}

## Test the Service

```bash
curl -i $PROXY_IP/httpbin/anything
```
The results should look like this:
```
HTTP/1.1 200 OK
Date: Thu, 15 Dec 2022 21:31:47 GMT
Content-Type: application/json
Content-Length: 341
Connection: keep-alive
Server: gunicorn/19.9.0
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 1
Via: kong/3.1.1

{
  "args": {},
  "data": "",
  "files": {},
  "form": {},
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.org",
    "User-Agent": "curl/7.86.0",
    "X-Amzn-Trace-Id": "Root=1-639b9243-7cdb670008b8189a5948d619"
  },
  "json": null,
  "method": "GET",
  "origin": "136.25.153.9",
  "url": "http://httpbin.org/anything"
}
```

[0]: https://kubernetes.io/docs/concepts/services-networking/service/#services-without-selectors
