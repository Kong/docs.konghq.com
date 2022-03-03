---
title: AWS Secrets Manager
beta: true
badge: enterprise
---

## Configuration

[AWS Secrets Manager](https://aws.amazon.com/secrets-manager/) can be configured in multiple ways. The current version of Kong Gateway's implementation only supports
configuring via environment variables.

```bash
export AWS_ACCESS_KEY_ID=<access_key_id>
export AWS_SECRET_ACCESS_KEY=<secrets_access_key>
export AWS_REGION=<aws-region>
```

## Examples

For example, let's use an AWS Secrets Manager Secret with the name `my-secret-name`.

In this object, you have multiple key=value pairs.

```json
{
  "foo": "bar",
  "snip": "snap",
}
```

Access these secrets from `my-secret-name` like this:

```bash
{vault://aws/my-secret-name/foo}
{vault://aws/my-secret-name/snap}
```

## Entity

The Vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the Vaults entity.

{% navtabs codeblock %}
{% navtab cURL %}

```bash
curl -i -X PUT http://<hostname>:8001/vaults-beta/my-aws-sm-vault  \
  --data name=aws \
  --data description="Storing secrets in AWS Secrets Manager" \
  --data config.region="us-east-1"
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http PUT :8001/vaults-beta/my-aws-sm-vault name="aws" \
  description="Storing secrets in AWS Secrets Manager" \
  config.region="us-east-1" \
  -f 
```

{% endnavtab %}
{% endnavtabs %}

Result:

```json
{
    "config": {
        "region": "us-east-1"
    },
    "created_at": 1644942689,
    "description": "Storing secrets in AWS Secrets Manager",
    "id": "2911e119-ee1f-42af-a114-67061c3831e5",
    "name": "aws",
    "prefix": "my-aws-sm-vault",
    "tags": null,
    "updated_at": 1644942689
}
```

With the Vault entity in place, you can now reference the secrets. This allows you to drop the `AWS_REGION`
environment variable.

```bash
{vault://my-aws-sm-vault/my-secret-name/foo}
{vault://my-aws-sm-vault/my-secret-name/snap}
```

## Advanced Examples

You can create multiple entities, which lets you have secrets in different regions:

```bash
http PUT :8001/vaults-beta/aws-eu-central-vault name=aws config.region="eu-central-1" -f 
http PUT :8001/vaults-beta/aws-us-west-vault name=aws config.region="us-west-1" -f 
```

This lets you source secrets from different regions:

```bash
{vault://aws-eu-central-vault/my-secret-name/foo}
{vault://aws-us-west-vault/my-secret-name/snap}
```
