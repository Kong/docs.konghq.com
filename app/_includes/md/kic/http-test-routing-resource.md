{%- assign path = include.path | default: '/echo' %}
{%- assign hostname = include.hostname | default: 'kong.example' %}
{%- assign name = include.name | default: 'echo' %}
{%- assign service = include.service | default: 'echo' %}
{%- assign port = include.port | default: '1027' %}

{% capture the_code %}
{% navtabs api %}
{% navtab Gateway API %}
{% assign gwapi_version = "v1" %}
{% if_version lte:2.12.x %}
{% assign gwapi_version = "v1beta1" %}
{%- endif_version %}
```bash
echo "
apiVersion: gateway.networking.k8s.io/{{ gwapi_version }}
kind: HTTPRoute
metadata:
  name: {{ name }}
  annotations:{% if include.annotation_rewrite %}
    konghq.com/rewrite: '{{ include.annotation_rewrite }}'{% endif %}
    konghq.com/strip-path: 'true'
spec:
  parentRefs:
  - name: kong
{% unless include.skip_host %}  hostnames:
  - '{{ hostname }}'
{% endunless %}  rules:
  - matches:
    - path:
        type: {{ include.route_type }}
        value: {{ path }}
    backendRefs:
    - name: {{ service }}
      kind: Service
      port: {{ port }}
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Ingress %}
```bash
echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ name }}
  annotations:{% if include.annotation_rewrite %}
    konghq.com/rewrite: '{{ include.annotation_rewrite }}'{% endif %}
    konghq.com/strip-path: 'true'
spec:
  ingressClassName: kong
  rules:
  - {% unless include.skip_host %}host: {{ hostname }}
    {% endunless %}http:
      paths:
      - path: {% if include.route_type == 'RegularExpression' %}/~{% endif %}{{ path }}
        pathType: ImplementationSpecific
        backend:
          service:
            name: {{ service }}
            port:
              number: {{ port }}
" | kubectl apply -f -
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{% if include.indent %}
{{ the_code | indent }}
{% else %}
{{ the_code }}
{% endif %}

{% unless include.no_results %}
The results should look like this:

{% capture the_code %}
{% navtabs codeblock %}
{% navtab Gateway API %}
```text
httproute.gateway.networking.k8s.io/{{ name }} created
```
{% endnavtab %}
{% navtab Ingress %}
```text
ingress.networking.k8s.io/{{ name }} created
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{% if include.indent %}
{{ the_code | indent }}
{% else %}
{{ the_code }}
{% endif %}
{% endunless %}