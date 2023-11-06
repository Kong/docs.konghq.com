{% unless include.skip_header %}## Add the konghq.com/plugin annotation
{% endunless %}{% capture the_code %}
{% navtabs api %}
{% navtab Gateway API %}
```bash
kubectl annotate httproute {{ include.name }} konghq.com/plugins='{{ include.plugins }}'
```
{% endnavtab %}
{% navtab Ingress %}
```bash
kubectl annotate ingress {{ include.name }} konghq.com/plugins='{{ include.plugins }}'
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{% if include.indent %}{{ the_code | indent }}{% else %}{{ the_code }}{% endif %}