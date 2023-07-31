---
title: Secrets Rotation
---

Secrets rotation is a process of updating secrets. Regular rotations of secrets is considered a good
practice. Here are some reasons why secrets rotation is important:

* Reducing impact of compromised secrets
* Enhancing resilience against brute-force attacks
* Complying with security regulations
* Maintaining separation of duties
* Adapting to evolving threats
* Mitigating the effects of insider threats

Kong needs to hold many types of secrets to be able to process requests, and to integrate with other
systems and clients:

* TLS certificates
* Credentials and API keys (to access databases, identity providers, and other services)
* Cryptographic keys (digital signing and encryption)

There are two main ways to rotate secrets:

* Rotate periodically using TTLs (e.g. check for new TLS certificate once per day)
* Rotate on failure (e.g. on database authentication failure, check if the secrets were updated, and try again)

Kong supports both methods for rotating secrets. Rotation on failure requires code to be written,
and thus it has limited support in Kong (Postgres credentials for now). There is an experimental
Kong PDK API that can be used to rotate secrets on failure: [kong.vault.try](/gateway/{{page.kong_version}}/plugin-development/pdk/kong.vault/#kongvaulttrycallback-options).

## Periodically rotating secrets using TTLs

Kong automatically rotates secrets *once every minute*, through a background job. This allows uncoupling the secret rotation process from proxying. It has some consequences:

* The once-per-minute refresh rate means that a secret with a TTL of 30 seconds might take up to 60 seconds to refresh in the least favorable scenario.
* Additionally, if the sum of TTL and `resurrect_ttl` is less than 60 seconds for a given secret, it won't be refreshed or resurrected correctly.

The TTL based rotation works with most of the Kong supported vaults, including:

* [AWS Secrets Manager](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/aws-sm/)
* [GCP Secrets Manager](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/gcp-sm/)
* [HashiCorp Vault](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/hashicorp-vault/)

When rotating with TTLs, it is usually useful to have two versions of the same secret valid at the same time.
This means that following steps occur during secrets rotation:

1. A new secret (or secret version) is created, resulting in three valid ones.
2. All the three secrets are verified that they work.
3. The oldest secret (or secret version) is removed/revoked or made otherwise invalid, resulting in two valid ones.

### Configuring AWS Secrets Manager Secrets Rotation using TTLs

The default [AWS Secrets Manager](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/aws-sm/)
vault TTLs can be configured through `kong.conf` or environment variables (the values are in seconds):

```bash
KONG_VAULT_AWS_TTL=300
KONG_VAULT_AWS_NEG_TTL=60
KONG_VAULT_AWS_RESURRECT_TTL=300
```

All AWS secret references will inherit these settings by default, e.g.:

```bash
{vault://aws/my-secret-name/foo}
```

You can override or set the TTLs directly with the references too: 

```bash
{vault://aws/my-secret-name/foo?ttl=600&neg_ttl=30&resurrect_ttl=600}
```

You can also create multiple vaults for different types of secrets,
and set the TTLs by secret types, e.g.:


```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/aws-certs  \
  --data name=aws \
  --data description="Storing secrets in AWS Secrets Manager" \
  --data config.region="us-east-1" \
  --data config.ttl=21600
```

Now when using certificates you can reference them with:

```bash
{vault://aws-certs/certs/web-site}
```

The secrets (certificates in this case) referenced with `aws-certs` vault
will share the same 6 hours TTL, and will be rotated one minute earlier than
their expiry.

### Configuring GCP Secrets Manager Secrets Rotation using TTLs

The default [GCP Secrets Manager](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/gcp-sm/)
vault TTLs can be configured through `kong.conf` or environment variables (the values are in seconds):

```bash
KONG_VAULT_GCP_TTL=300
KONG_VAULT_GCP_NEG_TTL=60
KONG_VAULT_GCP_RESURRECT_TTL=300
```

All GCP secret references will inherit these settings by default, e.g.:

```bash
{vault://gcp/my-secret-name/foo}
```

You can override or set the TTLs directly with the references too:

```bash
{vault://gcp/my-secret-name/foo?ttl=600&neg_ttl=30&resurrect_ttl=600}
```

You can also create multiple vaults for different types of secrets,
and set the TTLs by secret types, e.g.:

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/gcp-certs  \
  --data name=gcp \
  --data description="Storing secrets in GCP Secrets Manager" \
  --data config.project_id="my_project_id-1" \
  --data config.ttl=21600
```

Now when using certificates you can reference them with:

```bash
{vault://gcp-certs/certs/web-site}
```

The secrets (certificates in this case) referenced with `gcp-certs` vault
will share the same 6 hours TTL, and will be rotated one minute earlier than
their expiry.

### Configuring HashiCorp Vault Secrets Rotation using TTLs

The default [HashiCorp Vault](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/hashicorp-vault/)
TTLs can be configured through `kong.conf` or environment variables (the values are in seconds):

```bash
KONG_VAULT_HCV_TTL=300
KONG_VAULT_HCV_NEG_TTL=60
KONG_VAULT_HCV_RESURRECT_TTL=300
```

All HCV secret references will inherit these settings by default, e.g.:

```bash
{vault://hcv/my-secret-name/foo}
```

You can override or set the TTLs directly with the references too:

```bash
{vault://hcv/my-secret-name/foo?ttl=600&neg_ttl=30&resurrect_ttl=600}
```

You can also create multiple vaults for different types of secrets,
and set the TTLs by secret types, e.g.:

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/hcv-certs  \
  --data name=hcv \
  --data description="Storing secrets in HashiCorp Vault" \
  --data config.token="<my-token>" \
  --data config.ttl=21600
```

Now you can reference certificates with:

```bash
{vault://hcv-certs/certs/web-site}
```

The secrets (certificates in this case) referenced with `hcv-certs` vault
will share the same 6 hours TTL, and will be rotated one minute earlier than
their expiry.
