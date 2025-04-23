---
title: Custom plugins in Dedicated Cloud Gateways
content_type: reference
---

With Dedicated Cloud Gateways, {{site.konnect_short_name}} can stream custom plugins from the control plane to the data plane.

This means that the control plane becomes a single source of truth for plugin versions. You only need to upload a plugin once, to the control plane, and {{site.konnect_short_name}} handles distributing the plugin code to all data planes in that control plane.

Compared to the manual process required in a regular hybrid {{site.konnect_short_name}} deployment, custom plugin streaming in Dedicated Cloud Gateways provides the following benefits:
* Faster custom plugin distribution
* Minimal manual maintenance
* The control plane is the single source of truth

## Prerequisites

* Your [custom plugin](/gateway/latest/plugin-development/) meets the following requirements:
  * Each custom plugin must have a unique name.
  * Each custom plugin can have a maximum of 1 `handler.lua` file and 1 `schema.lua` file.
  * The plugin can't execute in the `init_worker` phase and can't set any timers.
  * The plugin must be written in Lua. No other languages are supported.
* You have a [personal access token or system access token](/konnect/org-management/access-tokens) for the {{site.konnect_short_name}} API

## Adding a custom plugin to a Dedicated Cloud Gateway deployment

Upload custom plugin schema and handler files to create a configurable entity in {{site.konnect_short_name}}.
If you prefer using the {{site.konnect_short_name}} UI, you can also upload these files through the Plugins menu in [Gateway Manager](https://cloud.konghq.com/gateway-manager/).

{:.important}
> The name you give the plugin must be identical to the name of the plugin in the schema file.

Using the following command, make a `POST` request to the [`/custom-plugins`](/konnect/api/control-plane-configuration/latest/#/operations/list-custom-plugin) endpoint of the {{site.konnect_short_name}} Control Plane Config API:

```sh
curl -X POST https://{region}.api.konghq.com/v2/control-planes/{control-plane-id}/core-entities/custom-plugins \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {your-access-token}" \
  -d "$(jq -n \
      --arg handler "$(cat handler.lua)" \
      --arg schema "$(cat schema.lua)" \
      '{"handler":$handler,"name":"streaming-headers","schema":$schema}')" \
    | jq
```

This request returns an `HTTP 200` response with the schema and handler for your plugin as a JSON object.

Once a custom plugin is uploaded to a Dedicated Cloud Gateway control plane, it can be managed like any other plugin, using any of the following tools:
* [decK](/konnect/gateway-manager/declarative-config/)
* [{{site.konnect_short_name}} Control Plane Config API](/konnect/api/control-plane-configuration/latest/#/operations/list-custom-plugin)
* [{{site.konnect_short_name}} UI](https://cloud.konghq.com/)

## More information

* [Custom plugin schema endpoints (Control Plane Config API)](/konnect/api/control-plane-configuration/latest/#/Custom%20Plugin%20Schemas)
* [Custom plugin template](https://github.com/Kong/kong-plugin)
* [Plugin development guide](/gateway/latest/plugin-development/)
* [PDK reference](/gateway/latest/plugin-development/pdk/)
