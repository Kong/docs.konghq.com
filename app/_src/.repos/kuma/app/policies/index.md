---
layout: policies
title: Policies
subTitle: Bundled policies for your service traffic and network configuration.
themeContainerClasses: 'no-sidebar'

# the data that is used to build this page
policies:
  - section: security
    sectionTitle: Security
    sectionSubTitle: Identity, Encryption and Compliance
    items:
      - title: Mesh / Multi-Mesh
        url: /docs/latest/policies/mesh/
        icon: /assets/images/icons/policies/icon-mesh-multi-tenancy@2x.png
      - title: Mutual TLS (mTLS)
        url: /docs/latest/policies/mutual-tls/
        icon: /assets/images/icons/policies/icon-mtls@2x.png
      - title: Traffic Permissions
        url: /docs/latest/policies/traffic-permissions/
        icon: /assets/images/icons/policies/icon-traffic-control@2x.png
  - section: traffic-control
    sectionTitle: Traffic Control
    sectionSubTitle: Routing, Ingress, Failover
    items:
      - title: Traffic Route
        url: /docs/latest/policies/traffic-route/
        icon: /assets/images/icons/policies/icon-traffic-route@2x.png
      - title: Health Check
        url: /docs/latest/policies/health-check/
        icon: /assets/images/icons/policies/icon-healthcheck@2x.png
      - title: Circuit Breaker
        url: /docs/latest/policies/circuit-breaker/
        icon: /assets/images/icons/policies/icon-circuitbreaker.png
      - title: Fault Injection
        url: /docs/latest/policies/fault-injection
        icon: /assets/images/icons/policies/icon-fault-injection@2x.png
      - title: Kong Gateway
        url: /docs/latest/explore/gateway/
        icon: /assets/images/icons/policies/icon-kong-logo.png
      - title: External Services
        url: /docs/latest/policies/external-services/
        icon: /assets/images/icons/policies/icon-external-services.png
      - title: Retries
        url: /docs/latest/policies/retry/
        icon: /assets/images/icons/policies/retry@2x.png
      - title: Timeouts
        url: /docs/latest/policies/timeout/
        icon: /assets/images/icons/policies/icon-timeout@2x-80.jpg
      - title: Rate Limit
        url: /docs/latest/policies/rate-limit/
        icon: /assets/images/icons/policies/icon-rate-limits.png
      - title: Virtual Outbound
        url: /docs/latest/policies/virtual-outbound/
        icon: /assets/images/icons/policies/virtual-outbound@2x.png
  - section: observability
    sectionTitle: Observability
    sectionSubTitle: Metrics, Logs and Traces
    items:
      - title: Traffic Metrics
        url: /docs/latest/policies/traffic-metrics/
        icon: /assets/images/icons/policies/icon-dataplane-metrics@2x.png
      - title: Service Map
        url: /docs/latest/explore/observability/#datasource-and-service-map
        icon: /assets/images/icons/policies/service-map@2x.png
      - title: Traffic Trace
        url: /docs/latest/policies/traffic-trace/
        icon: /assets/images/icons/policies/icon-traffic-trace@2x.png
      - title: Traffic Log
        url: /docs/latest/policies/traffic-log/
        icon: /assets/images/icons/policies/icon-traffic-log@2x.png
  - section: advanced
    sectionTitle: Advanced
    sectionSubTitle: Envoy configuration and Miscellaneous
    items:
      - title: Proxy Template
        url: /docs/latest/policies/proxy-template/
        icon: /assets/images/icons/policies/icon-proxy-template@2x.png
      - title: DP/CP Security
        url: /docs/latest/security/certificates/#data-plane-proxy-to-control-plane-communication
        icon: /assets/images/icons/policies/icon-dc-cp-security@2x.png
---
