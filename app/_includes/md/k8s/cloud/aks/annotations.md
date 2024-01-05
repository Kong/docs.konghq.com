{%- assign private = "false" -%}
{%- if include.type == "private" -%}
 {%- assign private = "false" -%}
{%- endif %}
    ingressClassName: azure-application-gateway
    annotations:
      appgw.ingress.kubernetes.io/use-private-ip: "{{ private }}"