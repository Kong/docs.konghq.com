---
title: Install Kong Manager
book: kubernetes-install
chapter: 4
---

Kong Manager is the graphical user interface (GUI) for Kong Gateway. It uses the Kong Admin API under the hood to administer and control Kong Gateway.

{:.important}
> Kong's Admin API must be accessible over HTTP from your local machine to use Kong Manager


## Prerequisites

* [{{ site.base_gateway }} installed](/gateway/{{ page.release }}/install/kubernetes/proxy/)
* Kong's Admin API is accessible over HTTP from your local machine

## Installation

Kong Manager is served from the same node as the Admin API. To enable Kong Manager, make the following changes to your `values-cp.yaml` file.

1. Set `admin_gui_url`, `admin_gui_api_url` and `admin_gui_session_conf` under the `env` key.

    ```yaml
    env:
      admin_gui_url: http://manager.example.com
      admin_gui_api_url: http://admin.example.com
      # Change the secret and set cookie_secure to true if using a HTTPS endpoint
      admin_gui_session_conf: '{"secret":"secret","storage":"kong","cookie_secure":false}'
    ```

1. Replace `example.com` in the configuration with your domain.

1. Enable Kong Manager authentication under the `enterprise` key.

    ```yaml
    enterprise:
      rbac:
        enabled: true
        admin_gui_auth: basic-auth
    ```

{% include md/k8s/ingress-setup.md service="manager" release="cp" type="private" %}

## Testing

Visit the URL in `env.admin_gui_url` in a web browser to see the Kong Manager log in page. The default username is `kong_admin`, and the password is the value you set in `env.password` when installing the {{ site.base_gateway }} control plane in the previous step.

## Troubleshooting

### I can't log in to Kong Manager

Check that `env.password` was set in `values-cp.yaml` before installing Kong. {{ site.base_gateway }} generates a random admin password if this is not set. This password can not be recovered and you must reinstall Kong to set a new admin password.

### What are my login credentials?

The Kong super admin username is `kong_admin`, and the password is the value set in `env.password` in `values-cp.yaml`.

### Kong Manager shows a white screen

Ensure that `env.admin_gui_api_url` is set correctly in `values-cp.yaml`.