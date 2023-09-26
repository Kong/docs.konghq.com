---
title: Kong Gateway Plugins in Konnect
content_type: reference
---

Plugins lets you extend {{site.konnect_short_name}} functionality. 
You can choose from any number of [bundled plugins](/hub/?compatibility=konnect&support=kong-inc) 
in {{site.konnect_short_name}}, or write your own [custom plugins](#custom-plugins).

## Plugin configuration

You can manage both bundled and custom plugins through the 
[{% konnect_icon runtimes %} Gateway Manager](https://cloud.konghq.com/us/gateway-manager).

You can scope a plugin to a specific {{site.base_gateway}} entity, or apply it globally
within a control plane:

* A **scoped** plugin applies configuration only to a specific service, route,
consumer, or consumer group.

* A **global** plugin applies to all services, routes, consumers, and consumer 
groups in a control plane.


In both cases, plugins are managed within a specific control plane. If you need a plugin to 
apply to multiple control planes, configure a plugin instance separately for each one, 
or create a [control plane group](/konnect/gateway-manager/control-plane-groups/).

Open the **Plugins** menu from within a control plane to access its list of plugins:

![List of plugins in a control plane](/assets/images/docs/konnect/konnect-plugin-list.png)

### Custom plugins

You can also [apply your own custom plugins](/konnect/gateway-manager/plugins/add-custom-plugin/) 
through the Gateway Manager.

All that the {{site.konnect_short_name}} control plane needs is a Lua schema file. Using that
schema, it creates a plugin configuration object in {{site.konnect_short_name}}, which you
can access via the Konnect UI or the custom plugins API. This means that {{site.konnect_short_name}}
only sees a custom plugin's configuration options, and does not see any other data.

The schema for your custom plugin must be written in Lua. 
All other plugin files can be written in any supported language.

All plugin files must also be deployed to **each** {{site.base_gateway}} data plane node.

![Custom plugins](/assets/images/docs/konnect/konnect-custom-plugins.png){:.image-border}

{:.important}
> **Caution**: Carefully test the operation of any custom plugins before deploying
them to production. Kong is not responsible for the operation or support of any 
custom plugins, including any performance impacts on your {{site.konnect_short_name}}
or {{site.base_gateway}} deployments. 

### Application registration

Application registration is built into API Products.
[Enabling it on an API product version](/konnect/dev-portal/applications/enable-app-reg/)
also enables two plugins in read-only mode: ACL, and one of Key Auth or OpenID
Connect. These plugins appear in the service's plugin list, and you can view their
configurations, but you can't edit or delete them directly.

### Plugin limitations

Some bundled {{site.base_gateway}} plugins are not available in {{site.konnect_short_name}}, or
have configuration requirements specific to {{site.konnect_short_name}}.

* Rate limiting plugins default to the `redis` strategy, for which you must
provide your own Redis server. You can also use `local` to apply rate limiting
per individual data plane.

* The following plugins are not available with {{site.konnect_saas}}:
  * OAuth2 Authentication
  * Apache OpenWhisk
  * Vault Auth
  * Key Authentication - Encrypted
  * JWT Signer
  * TLS Handshake Modifier
  * TLS Metadata Headers

See the [plugin compatibility chart](/konnect/compatibility/)
for a breakdown of the pricing tiers that each plugin is available in, and for specific {{site.konnect_short_name}}
notes for each plugin.

