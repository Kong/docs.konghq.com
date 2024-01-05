{% if include.type == "private" %}
{% include md/k8s/cloud/{{include.provider}}/test-with-public-lb.md %}
{% endif %}

```yaml
{{ include.service }}:
  enabled: true
  http:
    enabled: true
  tls:
    enabled: false
  ingress:
    enabled: true
    hostname: {{ include.service }}.example.com
    path: /
    pathType: Prefix
{%- include md/k8s/cloud/{{include.provider}}/annotations.md type=include.type %}
```