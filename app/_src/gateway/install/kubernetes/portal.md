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

Kong Developer portal is deployed as part of the `kong-cp` deployment as it needs access to the database for the Portal API to manage API specifications and content.

1. Update the `values-cp.yaml` file to enable Dev Portal, merging the following values in to your existing `values-cp.yaml` file.

    ```yaml
    env:
      # Portal configuration
      # CHANGE THESE VALUES
      portal_gui_protocol: http
      portal_gui_host: portal.example.com
      portal_api_url: http://portalapi.example.com
      portal_session_conf: '{"cookie_name": "portal_session", "secret": "PORTAL_SUPER_SECRET", "storage": "kong", "cookie_secure": false, "cookie_domain":".example.com"}'
    
    # Enable Developer Portal
    enterprise:
      portal:
        enabled: true
    ```

1. Update the portal hostname values in `values-cp.yaml`.

    - `env.portal_gui_protocol`: The protocol to use for the GUI (http or https)
    - `env.portal_gui_host`: The hostname that you'll use to reach the portal
    - `env.portal_api_url`: The publicly accessible API URL for dev portal data
    - `env.portal_session_conf`: Update the value in `secret` and `cookie_domain`

{% include md/k8s/ingress-setup.md service="portal" release="cp" type="public" skip_release=true skip_ingress_controller_install=true skip_dns=true %}

{% include md/k8s/ingress-setup.md service="portalapi" release="cp" type="public" skip_ingress_controller_install=true skip_dns=true %}

1. Fetch the `Ingress` IP address and update your DNS records to point at the Ingress address. You can configure DNS manually, or use a tool such as [external-dns](https://github.com/kubernetes-sigs/external-dns) to automate DNS configuration.

    Both `portal` and `portalapi` are accessible using the same `LoadBalancer`. Use the endpoint returned by the following command to configure both `portal.example.com` and `portalapi.example.com`.

    ```bash
    kubectl get ingress -n kong kong-cp-kong-portal -o jsonpath='{range .status.loadBalancer.ingress[0]}{@.ip}{@.hostname}{end}'
    ```

## Enable the Dev Portal

The Kong Developer Portal is not enabled by default in a new {{ site.base_gateway }} installation. Use the Admin API to enable the portal. Ensure you change the domain and `Kong-Admin-Token` values to match your installation.

```bash
curl -X PATCH http://admin.example.com/default/workspaces/default -d config.portal=true -H 'Kong-Admin-User: kong_admin' -H 'Kong-Admin-Token: YOUR_PASSWORD'
```

## Testing

Visit <http://portal.example.com/> in a browser. You will see a page that says "Built with Kong" with three sample OpenAPI specifications.

## Troubleshooting

### I can't log in

If the screen refreshes but you are not logged in to the dev portal, check that `cookie_domain` is set correctly in `values-cp.yaml`. Cookies are set on the portal API domain by default. `cookie_domain` is required to allow the portal to read authentication cookies from the portal API.
