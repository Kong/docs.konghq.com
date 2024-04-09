{% assign repository = 'kong/kong-gateway' %}
{% assign version = page.versions.ee %}
{% assign enterprise = 'true' %}

{% if include.package == 'oss' %}
{% assign repository = 'kong' %}
{% assign version = page.versions.ce %}
{% assign enterprise = 'false' %}
{% endif %}

```yaml
# Do not use {{ site.kic_product_name }}
ingressController:
  enabled: false

image:
  repository: {{ repository }}
  tag: "{{ version }}"

# Mount the secret created earlier
secretVolumes:
  - kong-cluster-cert

env:
  # data_plane nodes do not have a database
  role: data_plane
  database: "off"

  # Tell the data plane how to connect to the control plane
  cluster_control_plane: kong-cp-kong-cluster.kong.svc.cluster.local:8005
  cluster_telemetry_endpoint: kong-cp-kong-clustertelemetry.kong.svc.cluster.local:8006

  # Configure control plane / data plane authentication
  lua_ssl_trusted_certificate: /etc/secrets/kong-cluster-cert/tls.crt
  cluster_cert: /etc/secrets/kong-cluster-cert/tls.crt
  cluster_cert_key: /etc/secrets/kong-cluster-cert/tls.key

# Enterprise functionality
enterprise:
  enabled: {{ enterprise }}
  license_secret: kong-enterprise-license

# The data plane handles proxy traffic only
proxy:
  enabled: true

# These roles are served by the kong-cp deployment

{%- if_version lte:3.4.x %}
admin:
  enabled: false

portal:
  enabled: false

portalapi:
  enabled: false

manager:
  enabled: false
{% else %}
admin:
  enabled: false

manager:
  enabled: false
{% endif_version -%}
```