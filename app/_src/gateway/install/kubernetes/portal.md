---
title: Kong Developer Portal
book: kubernetes-install
chapter: 5
---

This guide shows how to deploy Kong Developer Portal, which is a self-hosted portal that ships as part of [[{{ site.ee_product_name  }}]]. For new developer portal deployments, we recommend using the <a href="https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=gateway-konnect&utm_content=kubernetes-install">{{ site.konnect_saas }} developer portal</a>.

## Prerequisites

* [{{ site.base_gateway }} installed](/gateway/{{ page.release }}/install/kubernetes/proxy/)
* Kong's Admin API is accessible over HTTP from your local machine

## Installation

...

1. Create a `values-portal.yaml` file.

    ```yaml
    # Do not use {{ site.kic_product_name }}
    ingressController:
      enabled: false
    
    image:
      repository: kong/kong-gateway
      tag: "3.4"
    
    env:
      # Database
      # CHANGE THESE VALUES
      database: postgres
      pg_database: kong
      pg_user: kong
      pg_password: demo123
      pg_host: kong-cp-postgresql.kong.svc.cluster.local
      pg_ssl: "on"

      # Portal configuration
      # CHANGE THESE VALUES
      portal_gui_protocol: http
      portal_gui_host: portal.example.com
      portal_api_url: http://portalapi.example.com
      portal_session_conf: '{"cookie_name": "portal_session", "secret": "PORTAL_SUPER_SECRET", "storage": "kong"}'
    
    # Enable enterprise functionality
    enterprise:
      enabled: true
      license_secret: kong-enterprise-license
    
    # Enable Developer Portal
    portal:
      enabled: true

    portalapi:
      enabled: true
    
    # These roles will be served by different Helm releases
    migrations:
      preUpgrade: false
      postUpgrade: false

    cluster:
      enabled: false
    
    clustertelemetry:
      enabled: false
    
    proxy:
      enabled: false
    
    admin:
      enabled: false

    manager:
      enabled: false
    ```

1. Update the database connection values in `values-portal.yaml`.

    - `env.pg_database`: The database name to use
    - `env.pg_user`: Your database username
    - `env.pg_password`: Your database password
    - `env.pg_host`: The hostname of your Postgres database
    - `env.pg_ssl`: Use SSL to connect to the database

1. Update the portal hostname values in `values-portal.yaml`.

    - `env.portal_gui_protocol`: The protocol to use for the GUI (http or https)
    - `env.portal_gui_host`: The hostname that you'll use to reach the portal
    - `env.portal_api_url`: The publicly accessible API URL for dev portal data
    - `env.portal_session_conf`: Update the value in `secret`

1. Run `helm install` to create the release.

    ```bash
    helm install kong-portal kong/kong -n kong --values ./values-portal.yaml
    ```

1. Run `kubectl get pods -n kong`. Ensure that the control plane is running as expected.

    ```
    NAME                                 READY   STATUS
    kong-cp-kong-7bb77dfdf9-x28xf        1/1     Running
    ```

## Testing

...

## Next Steps

...