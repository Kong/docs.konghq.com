{%- assign path = include.path | default: '/echo' %}
{%- assign hostname = include.hostname | default: 'kong.example' %}
{%- assign name = include.name | default: 'echo' %}
{%- assign service = include.service | default: 'echo' %}
{%- assign port = include.port | default: '1027' %}
  {% capture the_code %}
{% navtabs api %}
{% navtab Ingress %}
```bash
echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ name }}
  annotations:
    konghq.com/strip-path: 'true'
spec:
  ingressClassName: kong
  rules:
  - host: {{ hostname }}
    http:
      paths:
      - path: {{ path }}
        pathType: ImplementationSpecific
        backend:
          service:
            name: {{ service }}
            port:
              number: {{ port }}
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Gateway APIs %}
```bash
echo "
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: {{ name }}
  annotations:
    konghq.com/strip-path: 'true'
spec:
  parentRefs:
  - name: kong
  hostnames:
  - '{{ hostname }}'
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: {{ path }}
    backendRefs:
    - name: {{ service }}
      kind: Service
      port: {{ port }}
" | kubectl apply -f -
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{% if include.no_indent %}
{{ the_code }}
{% else %}
{{ the_code | indent }}
{% endif %}

The results should look like this:

{% capture the_code %}
{% navtabs codeblock %}
{% navtab ingress %}
```text
ingress.networking.k8s.io/{{ name }} created
```
{% endnavtab %}
{% navtab Gateway APIs %}
```text
httproute.gateway.networking.k8s.io/{{ name }} created
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{% if include.no_indent %}
{{ the_code }}
{% else %}
{{ the_code | indent }}
{% endif %}