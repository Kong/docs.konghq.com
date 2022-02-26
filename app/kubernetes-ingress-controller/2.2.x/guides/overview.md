---
title: Guides
---

Follow one of the guides to learn more about how to use
the {{site.kic_product_name}}:

- [Getting started](/kubernetes-ingress-controller/{{page.kong_version}}/guides/getting-started) with the {{site.kic_product_name}}
- [Getting started using Istio](/kubernetes-ingress-controller/{{page.kong_version}}/guides/getting-started-istio) with the {{site.kic_product_name}} and Istio
- [Using KongPlugin resource](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kongplugin-resource)
  This guide walks through setting up plugins in Kong using a declarative
  approach.
- [Using KongIngress resource](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kongingress-resource)
  This guide explains how the KongIngress resource can be used to change Kong
  specific settings like load-balancing, health-checking and proxy behaviour.
- [Using KongConsumer resources](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-consumer-credential-resource)
  This guide walks through how Kubernetes native declarative configuration
  can be used to dynamically provision credentials for authentication purposes
  in the Ingress layer.
- [Using JWT and ACL KongPlugin resources](/kubernetes-ingress-controller/{{page.kong_version}}/guides/configure-acl-plugin)
  This guides walks you through configuring the JWT plugin and ACL plugin for
  authentication purposes at the Ingress layer
- [Using cert-manager with Kong](/kubernetes-ingress-controller/{{page.kong_version}}/guides/cert-manager)
  This guide walks through how to use cert-manager along with Kong Ingress
  Controller to automate TLS certificate provisioning and using them
  to encrypt your API traffic.
- [Configuring a fallback service](/kubernetes-ingress-controller/{{page.kong_version}}/guides/configuring-fallback-service)
  This guide walks through how to setup a fallback service using Ingress
  resource. The fallback service will receive all requests that don't
  match against any of the defined Ingress rules.
- [Using external service](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-external-service)
  This guide shows how to expose services running outside Kubernetes via Kong,
  using [External Name](https://kubernetes.io/docs/concepts/services-networking/service/#externalname)
  Services in Kubernetes.
- [Configuring HTTPS redirects for your services](/kubernetes-ingress-controller/{{page.kong_version}}/guides/configuring-https-redirect)
  This guide walks through how to configure the {{site.kic_product_name}} to
  redirect HTTP request to HTTPS so that all communication
  from the external world to your APIs and microservices is encrypted.
- [Using Redis for rate-limiting](/kubernetes-ingress-controller/{{page.kong_version}}/guides/redis-rate-limiting)
  This guide walks through how to use Redis for storing rate-limit information
  in a multi-node Kong deployment.
- [Integrate the {{site.kic_product_name}} with Prometheus/Grafana](/kubernetes-ingress-controller/{{page.kong_version}}/guides/prometheus-grafana)
  This guide walks through the steps of how to deploy the {{site.kic_product_name}}
  and Prometheus to obtain metrics for the traffic flowing into your
  Kubernetes cluster.
- [Configuring circuit-breaker and health-checking](/kubernetes-ingress-controller/{{page.kong_version}}/guides/configuring-health-checks)
  This guide walks through the usage of Circuit-breaking and health-checking
  features of the {{site.kic_product_name}}.
- [Setting up custom plugin](/kubernetes-ingress-controller/{{page.kong_version}}/guides/setting-up-custom-plugins)
  This guide walks through
  installation of a custom plugin into Kong using
  ConfigMaps and Volumes.
- [Using ingress with gRPC](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-ingress-with-grpc)
  This guide walks through how to use the {{site.kic_product_name}} with gRPC.
- [Setting up upstream mTLS](/kubernetes-ingress-controller/{{page.kong_version}}/guides/upstream-mtls)
  This guide gives an overview of how to setup mutual TLS authentication
  between Kong and your upstream server.
- [Preserveing Client IP address](/kubernetes-ingress-controller/{{page.kong_version}}/guides/preserve-client-ip)
  This guide gives an overview of different methods to preserve the Client
  IP address.
- [Using KongClusterPlugin resource](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kongclusterplugin-resource)
  This guide walks through setting up plugins that can be shared across
  Kubernetes namespaces.
- [Using Kong with Knative](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kong-with-knative)
  This guide gives an overview of how to setup Kong as the Ingress point
  for Knative workloads.
- [Exposing TCP-based service](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-tcpingress)
  This guide gives an overview of how to use TCPIngress resource to expose
  non-HTTP based services outside a Kubernetes cluster.
- [Using mtls-auth plugin](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-mtls-auth-plugin)
  This guide gives an overview of how to use `mtls-auth` plugin and CA
  certificates to authenticate requests using client certificates.
- [Configuring custom entities in Kong](/kubernetes-ingress-controller/{{page.kong_version}}/guides/configuring-custom-entities)
  This guide gives an overview of how to configure custom entities for
  deployments of the {{site.kic_product_name}} running without a database.
- [Using OpenID-connect plugin](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-oidc-plugin)
  This guide walks through steps necessary to set up OIDC authentication.
