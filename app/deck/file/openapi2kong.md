---
title: openapi2kong
---

The `openapi2kong` command converts an OpenAPI specification to Kong's declarative configuration format.

* A Service is created, pointing to the URLs in the `servers` block
* One route per `operationId` is created
* If an `openIdConnect` `securityScheme` is present, an `openid-connect` plugin will be generated

## Get started

Converting an OpenAPI file to a Kong declarative configuration can be done in a single command:

```bash
deck file openapi2kong --spec oas.yaml --output-file kong.yaml
```

## Best practices

### ID Generation

The `openapi2kong` command will generate a declarative configuration file that contains an `id` for each entity. This ensures that even if the entity name (or any other identifying parameter) changes, it will update an entity in {{ site.base_gateway }} rather than deleting then recreating an entity.

If you have an existing {{ site.base_gateway }} instance, you can use the `--inso-compatible` flag to skip ID generation. In this instance, decK will match entities on a best effort basis using the `name` field.

If you have multiple teams using the same names and `operationId` values in their specifications, you can specify the `--uuid-base` flag to set a custom namespace when generating IDs.

To learn more about ID generation, see the [openapi2kong GitHub documentation](https://github.com/Kong/go-apiops/blob/main/docs/oas2kong-id-generation-deck.md#id-generation).

### Adding plugins

`openapi2kong` allows you to configure plugins directly in your OpenAPI specification by providing an `x-kong-plugin-PLUGIN-NAME` annotation at the root level to add it to the service, at the path level to add it to all routes on that path, or on an operation to add it to a specific route.

_However_, we do not recommend using this functionality. Routing and policy enforcement are generally owned by different teams, and you do not want to publish plugin configuration in an OpenAPI specification that is shared with customers.

We recommend using the [add-plugin](/deck/file/manipulation/plugins/) command after the `openapi2kong` command has been run.

If you _really_ want to embed plugin configuration in your OpenAPI specification, here is an example extension that adds the `request-termination` plugin to a route:

```yaml
x-kong-request-termination:
  status_code: 403
  message: So long and thanks for all the fish!
```

There are two exceptions to this recommendation:

* Configuring OpenID Connect scopes
* Dynamically generating request validator plugins for all endpoints

#### Configuring OpenID Connect scopes

OpenID Connect allows you to check for specific scopes when accessing a route. App development teams know which scopes are required for the paths their application serves.

To define scopes on a per-path level, use the `x-kong-security-openid-connect` annotation at the same level as `operationId`.

```yaml
x-kong-security-openid-connect:
  config:
    scopes_required: ["scope1", "scope2"]
```

#### Dynamic request-validator plugin configuration

The Kong `request-validator` plugin can validate incoming requests against a user-provided JSON schema.

The plugin can be configured manually, but `openapi2kong` can use the provided OpenAPI specification to configure the `request-validator` plugin for all routes automatically. To do enable this behavior, add the `x-kong-plugin-request-validator` at the root level to add it to all routes, at the path level to add it to all routes on that path, or on an operation to add it to a specific route.

Omitting the `body_schema` and `parameter_schema` configuration options tells `openapi2kong` to automatically inject the schema for the current endpoint when generating a {{ site.base_gateway }} declarative configuration file.

```yaml
x-kong-plugin-request-validator:
  config:
    verbose_response: true
```

## Custom x-kong extensions

The `openapi2kong` command supports the following custom `x-kong` extensions to customize the declarative configuration file generation:


| Annotation | Description | 
|------------|-------------|
| `x-kong-tags` | Specify the [tags](/gateway/api/admin-ee/latest/#/Tags) to use for each {{site.base_gateway}} entity generated. Tags can be overridden when doing the conversion. This can only be specified at the document level. |
| `x-kong-service-defaults` | The defaults for the [services](/gateway/api/admin-ee/latest/#/Services) generated from the `servers` object in the OpenAPI spec. These defaults can also be added to the `path` and `operation` objects, which will generate a new service entity. |
| `x-kong-upstream-defaults` | The defaults for [upstreams](/gateway/api/admin-ee/latest/#/Upstreams) generated from the `servers` object in the OpenAPI spec. These defaults can also be added to the `path` and `operation` objects, which will generate a new service entity. |
| `x-kong-route-defaults` | The defaults for the [routes](/gateway/api/admin-ee/latest/#/Routes) generated from `paths` in the OpenAPI spec. |
| `x-kong-name` | The name for the entire spec file. This is used for naming the service and upstream objects in {{site.base_gateway}}. If not given, it will use the `info.title` field to name these objects, or a random UUID if the `info.title` field is missing. Names are converted into valid identifiers. This directive can also be used on `path` and `operation` objects to name them. Similarly to `operationId`, each `x-kong-name` must be unique within the spec file. |
| `x-kong-plugin-<kong-plugin-name>` | Directive to add a plugin. The plugin name is derived from the extension name and is a generic mechanism that can add any type of plugin. This plugin is configured on a global level for the OpenAPI spec. As such, it is configured on the service entity, and applies on all paths and operations in this spec. <br><br> The plugin name can also be specified on paths and operations to override the config for that specific subset of the spec. In that case, it is added to the generated route entity. If new service entities are generated from `path` or `operation` objects, the plugins are copied over accordingly (for example, by having `servers` objects, or upstream or service defaults specified on those levels). <br><br> A consumer can be referenced by setting the `consumer` field to the consumer name or ID. <br><br>**Note:** Since the plugin name is in the key, only one instance of each plugin can be added at each level.|
|`securitySchemes.[...].x-kong-security-openid-connect` | Specifies that the [OpenID Connect plugin](/hub/kong-inc/openid-connect) is to be used to implement this `security scheme object`. Any custom configuration can be added as usual for plugins. |
| `components.x-kong` | Reusable {{site.base_gateway}} configuration components. All `x-kong` references must be under this key. It accepts the following referenceable elements: <br> &#8226; `x-kong-service-defaults`<br> &#8226; `x-kong-upstream-defaults` <br> &#8226; `x-kong-route-defaults` <br> &#8226; `x-kong-plugin-[...] plugin configurations` <br> &#8226; `x-kong-security-[...] plugin configurations` |

For more information and examples of these annotations, see the commented [example openapi2kong OAS](https://github.com/Kong/go-apiops/blob/main/docs/learnservice_oas.yaml).