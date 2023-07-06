The Salt Security Kong deployment is used to capture a mirror of application traffic and send it to the Salt Security Service for analysis.
This plugin has low CPU and memory consumption and adds no latency to the application since
it does not sit in line with the production traffic.
The plugin needs to see unencrypted traffic (after SSL termination)
to enable the Salt Security service to perform analysis.

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
