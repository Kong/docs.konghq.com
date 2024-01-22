{%- assign ingress_class = "gce" -%}
{%- if include.type == "private" -%}
 {%- assign ingress_class = "gce-internal" -%}
{%- endif %}
    annotations:
      kubernetes.io/ingress.class: {{ ingress_class }}