{% assign name = include.name | default: 'kotenok' %}
{%- assign credName = include.credName | default: 'gav' %}
```bash
echo "apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  name: {{ name }}
  annotations:
    kubernetes.io/ingress.class: kong
username: {{ name }}" | kubectl apply -f -
{% if credName %}
credentials:
- {{ credName }}
{% endif %}
```
Response:
```text
kongconsumer.configuration.konghq.com/{{ name }} created
```
