{% assign key = include.key | default: 'gav' %}
{%- assign credName = include.credName | default: 'credential' %}
```bash
kubectl create secret generic {{ credName }} \
  --from-literal=kongCredType=key-auth  \
  --from-literal=key={{ key }}
```
Output is similar to:
```text
secret/{{ credName }} created
```
