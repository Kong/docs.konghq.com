{%- assign lb_name = "kong-alb-public" -%}
{%- assign scheme = "internet-facing" -%}
{%- if include.type == "private" -%}
 {%- assign lb_name = "kong-alb-private" -%}
 {%- assign scheme = "internal" -%}
{%- endif %}
    ingressClassName: alb
    annotations:
      alb.ingress.kubernetes.io/load-balancer-name: {{ lb_name }}
      alb.ingress.kubernetes.io/group.name: demo.{{ lb_name }}
      alb.ingress.kubernetes.io/target-type: instance
      alb.ingress.kubernetes.io/scheme: {{ scheme }}
      alb.ingress.kubernetes.io/healthcheck-path: /
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'