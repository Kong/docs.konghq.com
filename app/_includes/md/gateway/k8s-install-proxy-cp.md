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
  # This is a control_plane node
  role: control_plane
  # These certificates are used for control plane / data plane communication
  cluster_cert: /etc/secrets/kong-cluster-cert/tls.crt
  cluster_cert_key: /etc/secrets/kong-cluster-cert/tls.key

  # Database
  # CHANGE THESE VALUES
  database: postgres
  pg_database: kong
  pg_user: kong
  pg_password: demo123
  pg_host: kong-cp-postgresql.kong.svc.cluster.local
  pg_ssl: "on"

  # Kong Manager password
  password: kong_admin_password

# Enterprise functionality
enterprise:
  enabled: {{ enterprise }}
  license_secret: kong-enterprise-license

# The control plane serves the Admin API
admin:
  enabled: true
  http:
    enabled: true

# Clustering endpoints are required in hybrid mode
cluster:
  enabled: true
  tls:
    enabled: true

clustertelemetry:
  enabled: true
  tls:
    enabled: true

# Optional features
{% if_version lte:3.4.x -%}
manager:
  enabled: false

portal:
  enabled: false

portalapi:
  enabled: false

# These roles will be served by different Helm releases
proxy:
  enabled: false
{% else -%}
manager:
  enabled: false

# These roles will be served by different Helm releases
proxy:
  enabled: false
{% endif_version -%}
```