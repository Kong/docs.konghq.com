---
title: Kong Vault
type: how-to
purpose: |
  How to configure Kong Vaults in KIC 
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

{{ site.base_gateway }} supports environment variables, HashiCorp Vault, AWS Secrets Manager and Google Cloud Secret Manager as a source for secret configuration. These vaults can be configured using environment variables on your `gateway` deployments.
{% if_version gte:3.1.x %}You can also configure vaults using the `KongVault` CRD.{% endif_version %}

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

1. Use this value `SECRET_REDIS_PASSWORD` in a `KongPlugin` definition.

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
      redis_password: '{vault://env/secret-redis-password}'
    ```

### HashiCorp Vault

{% navtabs  %}
{% navtab Environment variables %}
Configure the following in your `values.yaml`:

```yaml
gateway:
  customEnv:
    vault_hcv_protocol: "https"
    vault_hcv_host: "vault.default.svc.cluster.local"
    vault_hcv_port: "8200"
    vault_hcv_mount: "secret"
    vault_hcv_kv: "v2"
    vault_hcv_auth_method: "token"
    vault_hcv_token: "TOKENSTRINGHERE"
```
{% endnavtab %}
{% if_version gte:3.1.x %}
{% navtab KongVault CRD%}
Configure the following in your `values.yaml`:

```yaml
gateway:
  customEnv:
    vault_hcv_token: "TOKENSTRINGHERE"
```

Create a `KongVault` object in your Kubernetes cluster:

```yaml
apiVersion: configuration.konghq.com/v1alpha1
kind: KongVault
metadata:
  name: hcv-vault
spec:
    backend: hashicorp
    prefix: hcv
    description: "HashiCorp Vault"
    config:
        protocol: "https"
        host: "vault.default.svc.cluster.local"
        port: "8200"
        mount: "secret"
        kv: "v2"
        auth_method: "token"
```
{% endnavtab %}
{% endif_version gte:3.1.x %}
{% endnavtabs %}

Configure the following in your `values.yaml`:

### AWS Secrets Manager

{% navtabs  %}
{% navtab Environment variables %}
Configure the following in your `values.yaml`:

```yaml
gateway:
  customEnv:
    aws_access_key_id: ""
    aws_secret_access_key: ""
    aws_region: ""
    aws_session_token: ""
```
{% endnavtab %}
{% if_version gte:3.1.x %}
{% navtab KongVault CRD %}
Configure the following in your `values.yaml`:

```yaml
gateway:
  customEnv:
    aws_access_key_id: ""
    aws_secret_access_key: ""
    aws_session_token: ""
```

Create a `KongVault` object in your Kubernetes cluster:

```yaml
apiVersion: configuration.konghq.com/v1alpha1
kind: KongVault
metadata:
  name: aws-vault
spec:
    backend: aws
    prefix: aws
    description: "AWS Secrets Manager"
    config:
      region: "us-west-2"
```
{% endnavtab %}
{% endif_version gte:3.1.x %}
{% endnavtabs %}

### Google Cloud Secret Manager

Configure the following in your `values.yaml`:

```yaml
gateway:
  customEnv:
    gcp_service_account: '{"credentials": "here in JSON format. See gcp-project-RANDOM_ID.json"}'
```


{% if_version gte:3.1.x %}
## Configuring Vaults dynamically with the KongVault CRD

Kong vaults can be configured by creating `KongVault` objects in your Kubernetes cluster.
The `KongVault` CRD allows you to configure a vault backend details (its type, prefix, description) and the vault's connection details that are specific to the backend type.

{:.note}
> Please note that you still need to configure credentials used by your vault backend in your `values.yaml` file
> (e.g. `aws_secret_access_key`, `vault_hcv_token` etc.).

The following is an example of a `KongVault` definition for the AWS backend in `us-west-2` region:

```yaml
apiVersion: configuration.konghq.com/v1alpha1
kind: KongVault
metadata:
  name: aws-us-west-vault
spec:
  backend: aws
  prefix: aws-us-west
  description: "AWS Secrets Manager vault for us-west-2 region"
  config:
    region: us-west-2
```

You can also create another `KongVault` using the same backend type, but with different configuration details (e.g. a different region):

```yaml
apiVersion: configuration.konghq.com/v1alpha1
kind: KongVault
metadata:
  name: aws-us-east-vault
spec:
    backend: aws
    prefix: aws-us-east
    description: "AWS Secrets Manager vault for us-east-1 region"
    config:
        region: us-east-1
```

To refer to secrets stored in your vaults, you can use a `vault://<kong-vault-prefix>` prefix (with `<kong-vault-prefix>` substituted by `aws-us-east` or `aws-us-west`)
in your plugin configuration. For example:

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
  redis_password: '{vault://aws-us-east/secret-redis-password}'
```
{% endif_version %}
