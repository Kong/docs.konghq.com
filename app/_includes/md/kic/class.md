## Create a configuration group

Ingress and Gateway APIs controllers need configuration indicating which set of
routing configuration they should recognize, to allow multiple controller to
coexist in the same cluster. Before creating individual routes, you need to
create class configuration to associate routes with:

{% navtabs api %}
{% navtab Ingress %}

Official distributions of {{site.kic_product_name}} come with a `kong`
IngressClass by default. If `kubectl get ingressclass kong` does not return a
`not found` error, you can skip this command.

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: kong
spec:
  controller: ingress-controllers.konghq.com/kong
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Response %}
```text
ingressclass.networking.k8s.io/kong configured
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% navtab Gateway APIs %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "
---
apiVersion: gateway.networking.k8s.io/v1beta1
kind: GatewayClass
metadata:
  name: kong
{%- if_version gte: 2.6.x %}
  annotations:
    konghq.com/gatewayclass-unmanaged: 'true'
{%- endif_version %}
spec:
  controllerName: konghq.com/kic-gateway-controller
---
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: kong
{%- if_version lte: 2.5.x %}
  annotations:
    konghq.com/gateway-unmanaged: kong/kong-proxy
{%- endif_version %}
spec:
  gatewayClassName: kong
  listeners:
  - name: proxy
    port: 80
    protocol: HTTP
  - name: proxy-ssl
    port: 443
    protocol: HTTPS
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Response %}
```text
gatewayclass.gateway.networking.k8s.io/kong created
gateway.gateway.networking.k8s.io/kong created
```
{% endnavtab %}
{% endnavtabs %}

Once the controller has acknowledged the Gateway, it will show the proxy IP in
its status:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl get gateway kong
```
{% endnavtab %}
{% navtab Response %}
```text
NAME   CLASS   ADDRESS        READY   AGE
kong   kong    203.0.113.42   True    4m46s
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% endnavtabs %}

{{site.kic_product_name}} recognizes the `kong` IngressClass and
`konghq.com/kic-gateway-controller` GatewayClass
by default. Setting the `CONTROLLER_INGRESS_CLASS` or
`CONTROLLER_GATEWAY_API_CONTROLLER_NAME` environment variable to
another value overrides these defaults.
