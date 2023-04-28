## Add routing configuration

{%- assign path = include.path | default: '/echo' %}
{%- assign hostname = include.hostname | default: 'kong.example' %}
{%- assign name = include.name | default: 'echo' %}
{%- assign service = include.service | default: 'echo' %}

Create routing configuration to proxy `{{ path }}` requests to the echo server:

{% include_cached /md/kic/http-test-routing-resource.md kong_version=include.kong_version hostname=hostname path=path name=name service=service %}

Test the routing rule:

```bash
curl -i http://{{ hostname }}{{ path }} --resolve {{ hostname }}:80:$PROXY_IP
```
Response:
```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Length: 140
Connection: keep-alive
Date: Fri, 21 Apr 2023 12:24:55 GMT
X-Kong-Upstream-Latency: 0
X-Kong-Proxy-Latency: 1
Via: kong/3.2.2

Welcome, you are connected to node docker-desktop.
Running on Pod echo-7f87468b8c-tzzv6.
In namespace default.
With IP address 10.1.0.237.
...
```

If everything is deployed correctly, you should see the above response.
This verifies that {{site.base_gateway}} can correctly route traffic to an application running
inside Kubernetes.
