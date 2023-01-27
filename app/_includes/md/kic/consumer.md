{% assign name = include.name | default: 'kotenok' %}
{%- assign credName = include.credName %}
```bash
echo "apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  name: {{ name }}
  annotations:
    kubernetes.io/ingress.class: kong
username: {{ name }}
{% if credName -%}
credentials:
- {{ credName }}
{% endif -%}" | kubectl apply -f -
```
Response:
```text
kongconsumer.configuration.konghq.com/{{ name }} created
```
