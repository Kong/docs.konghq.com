{%- assign path = include.path | default: '/echo' %}
{%- assign hostname = include.hostname | default: 'kong.example' %}
{%- assign name = include.name | default: 'echo' %}
{%- assign service = include.service | default: 'echo' %}
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
              number: 1027
" | kubectl apply -f -
```
The results should look like this:
```text
ingress.networking.k8s.io/{{ name }} created
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
      port: 1027
" | kubectl apply -f -
```
The results should look like this:
```text
httproute.gateway.networking.k8s.io/{{ name }} created
```
{% endnavtab %}
{% endnavtabs %}
