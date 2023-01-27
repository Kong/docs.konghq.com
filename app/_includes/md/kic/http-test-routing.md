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
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Date: Thu, 10 Nov 2022 22:10:40 GMT
Server: echoserver
X-Kong-Upstream-Latency: 0
X-Kong-Proxy-Latency: 0
Via: kong/3.0.0



Hostname: echo-fc6fd95b5-6lqnc

Pod Information:
	node name:	kind-control-plane
	pod name:	echo-fc6fd95b5-6lqnc
	pod namespace:	default
	pod IP:	10.244.0.9
...
```

If everything is deployed correctly, you should see the above response.
This verifies that {{site.base_gateway}} can correctly route traffic to an application running
inside Kubernetes.
