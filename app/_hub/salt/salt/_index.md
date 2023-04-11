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
