---
title: Kong Vault
type: how-to
purpose: |
  How to configure Kong Vault using environment variables
enterprise: true
---

Secrets Management is a {{site.ee_product_name}} feature for [storing sensitive
plugin configuration](/gateway/latest/kong-enterprise/secrets-management/#referenceable-plugin-fields) 
separately from the visible plugin configuration. 

Secrets Management [supports several backend systems](/gateway/latest/kong-enterprise/secrets-management/backends/).
This guide uses the environment variable backend, which requires minimal
configuration and integrates well with Kubernetes' standard Secret-sourced
environment variables.

## Available Vaults

{{ site.base_gateway }} supports environment variables, Hashicorp Vault, AWS Secrets Manager and Google Secrets Manager as a source for secret configuration. These vaults can be configured using environment variables on your `gateway` deployments.

To learn more about the available vaults, see the [{{ site.base_gateway }} documentation](/gateway/latest/kong-enterprise/secrets-management/).


### Environment Vault

1.  Set an environment variable on your proxy Pod using `valueFrom.secretKeyRef` in your deployment. This example makes the `redis-password-secret` secret available using the environment variable vault.

    ```bash
    kubectl patch deploy -n kong kong-gateway --patch '
    {
      "spec": {
        "template": {
          "spec": {
            "containers": [
              {
                "name": "proxy",
                "env": [
                  {
                    "name": "SECRET_REDIS_PASSWORD",
                    "valueFrom": {
                      "secretKeyRef": {
                        "name": "redis-password-secret",
                        "key": "redis-password"
                      }
                    }
                  }
                ]
              }
            ]
          }
        }
      }
    }'
    ```

1. Use this value ` SECRET_REDIS_PASSWORD` in a `KongPlugin` definition.

    ```yaml
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: rate-limiting-example
    plugin: rate-limiting
    config:
      second: 5
      hour: 10000
      policy: redis
      redis_host: <redis_host>
      redis_password: "vault://env/secret-redis-password"
    ```


### Hashicorp Vault

Configure the following in your `values.yaml`:

```yaml
gateway:
  env:
    vault_hcv_protocol: "https"
    vault_hcv_host: "vault.default.svc.cluster.local"
    vault_hcv_port: "8200"
    vault_hcv_mount: "secret"
    vault_hcv_kv: "v2"
    vault_hcv_auth_method: "token"
    vault_hcv_token: "TOKENSTRINGHERE"
```

### AWS Secrets Manager

Configure the following in your `values.yaml`:

```yaml
gateway:
  customEnv:
    aws_access_key_id: ""
    aws_secret_access_key: ""
    aws_region: ""
    aws_session_token: ""
```

### Google Secrets Manager

Configure the following in your `values.yaml`:

```yaml
gateway:
  customEnv:
    gcp_service_account: '{"credentials": "here in JSON format. See gcp-project-RANDOM_ID.json"}'
```