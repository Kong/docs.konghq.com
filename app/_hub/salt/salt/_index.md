---
name: Salt Security
publisher: Salt Security

categories:
  - security

type: integration

desc: Integrate Kong API Gateway with Salt Security Discovery & Prevention for API-based apps
description: |
  The Salt Security Kong deployment is used to capture a mirror of application traffic and send it to the Salt Security Service for analysis.
  This plugin has low CPU and memory consumption and adds no latency to the application since
  it does not sit in line with the production traffic.
  The plugin needs to see unencrypted traffic (after SSL termination)
  to enable the Salt Security service to perform analysis.

#support_url:
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

#source_code:
  # (Optional) If your extension is open source, provide a link to your code.

#license_type:
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

#license_url:
  # (Optional) Link to your custom license.

#privacy_policy:
  # (Optional) If you have a custom privacy policy, place it here

#privacy_policy_url:
  # (Optional) Link to a remote privacy policy

#terms_of_service:
  # (Optional) Text describing your terms of service.

#terms_of_service_url:
  # (Optional) Link to your online TOS.

kong_version_compatibility:
  community_edition:
    compatible:
      - 1.2.x
      - 1.1.x
      - 1.0.x
      - 0.14.x
      - 0.13.x
      - 0.12.x
  enterprise_edition:
    compatible:
      - 0.35-x
      - 0.34-x
---

## Deployment

Salt Security is easy to deploy as a Kong module.

### Install the plugin

Once you have obtained the `.rock` file from your Salt Security distributor, install it using the LuaRocks package manager:

```shell
$ luarocks install kong-plugin-salt-agent-0.1.0-1.all.rock
```

If you need help with installation, see the documentation on [Installing a Plugin](/gateway/latest/plugin-development/distribution/).

### Configure the plugin

Register the Salt Security backend as a Kong service:

```shell
$ curl -X POST http://<kong-domain>:<kong-port>/services/<your-kong-service-id>/plugins/ \
  --data "name=salt-agent" \
  --data "config.salt_domain=<salt_domain>" \
  --data "config.salt_backend_port=<salt_backend_port>" \
  --data "config.salt_token=<salt_token>"
```
> Note: installation may be different between Kong versions.

### Plugin configuration reference

| Parameter                | Description          |
|--------------------------|----------------------|
|`config.salt_domain`      | Salt domain address. |
|`config.salt_backend_port`| Salt backend port. Defaults to 443 if `config.salt_backend_port` is not provided. |
|`config.salt_token`       | Salt-provided company token. |
