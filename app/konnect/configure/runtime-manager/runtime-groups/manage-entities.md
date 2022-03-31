---
title: Manage Entities in a Runtime Group
no_version: true
---

You can manage any {{site.base_gateway}} Services, Routes, consumer-scoped
entities, and global entities from within a runtime group.

A **global** entity is a set of configurations that apply to, or can be used
by, all objects in a runtime group. For example, if you set up a Proxy Caching
plugin in the default runtime group and set it to `Global`,
the plugin configuration will apply to all Services in the group.

Consumers, SNIs, upstreams, and certificates are all global entities. Plugins
can either be global or scoped.

## Configurable Gateway entities in Konnect

Through a runtime group, you can manage the following entities:

### Gateway Services

The **Gateway Service** configuration page lists all {{site.base_gateway}} Services
in the runtime group. Service entities are abstractions of each of your own
upstream services, such as a data transformation microservice, or a billing API.

Gateway Services can be exposed in ServiceHub, or managed though Runtime Manager
only:
* When you create a [Konnect Service implementation](/konnect/configure/servicehub/manage-services)
through the ServiceHub, it automatically creates a Gateway Service.
* You can also create a Gateway Service directly through Runtime Manager. This
Service won't be connected to any ServiceHub implementation.

To see if a Gateway Service is connected to the ServiceHub, open its
detail page from **Runtime Manager** > **Gateway Services**. If it's attached to an
implementation, you should see a tag in the following format: `_KonnectService:{SERVICE_NAME}`.

Learn more about [Services in Konnect](/konnect/configure/servicehub) or
check out the [Service object API reference](/gateway/latest/admin-api/#service-object)
for all configuration options.

### Routes

The **Routes** configuration page lists all Routes in the runtime group, including
Routes created through the ServiceHub. A Route defines rules to match client
requests, and is associated with a Gateway Service. You can edit any
Routes in the runtime group from here.

See the [Route object API reference](/gateway/latest/admin-api/#route-object)
for all configuration options.

### Consumers

The **Consumers** configuration page lists all consumers in the runtime group.
Consumer objects represent users of a service, and are most often used for
authentication. They provide a way to divide access to your services, and make
it easy to revoke that access without disturbing a service’s function.

See the [consumer object API reference](/gateway/latest/admin-api/#consumer-object)
for all configuration options.

### Plugins

The **Plugins** configuration page lists all plugins used by any
entities in the runtime group. Plugins let you extend proxy functionality by
adding rules, policies, transformations, and more on requests and responses.

Although you can see all plugins from this page, you can only edit _global_ or
_consumer-scoped_ plugins through the Runtime Manager.
[Service](/konnect/configure/servicehub/enable-service-plugin) and
[route](/konnect/configure/servicehub/enable-route-plugin) plugins must be managed
through the ServiceHub.

Learn more about [using plugins in Konnect](/konnect/configure/servicehub/plugins),
check out the [plugin object API reference](/gateway/latest/admin-api/#plugin-object),
or see all available plugins on the [Plugin Hub](/hub) for specific configuration
options for each plugin.

<!-- To do after merge: move plugins intro page to top level under "configure".
Plugin info is not ServiceHub-specific -->

### Upstreams

The **Upstream** configuration page lists all upstreams for incoming requests,
or from where the requests are being forwarded.

An upstream object represents a virtual hostname referring to your own
service/API. Upstreams can be used to health check, circuit break, and load
balance incoming requests over multiple services (targets).

See the [upstream object API reference](/gateway/latest/admin-api/#upstream-object)
for all configuration options.

### Certificates

The **Certificates** configuration page lists public certificates
that enable encrypted requests and peer certification validation.

This configuration page _does not_ manage runtime instance certificates. If you
need to update a runtime instance certificate, see
[Renew Certificates](/konnect/configure/runtime-manager/runtime-instances/renew-certificates).

A certificate object represents a public certificate and can be paired with a
corresponding private key. Certificates handle SSL/TLS termination for encrypted
requests, and can be used as a trusted CA store when validating the peer
certificate of a client or service.

See the [certificate object API reference](/gateway/latest/admin-api/#certificate-object)
for all configuration options.

### SNIs

The **SNIs** configuration page lists all SNIs configured in the runtime group.

An SNI object represents a many-to-one mapping of hostnames to a certificate.
A certificate object can have many hostnames associated with it, so when a
runtime instance receives an SSL request, it uses the SNI field in the
ClientHello to look up the associated certificate object.

See the [SNI object API reference](/gateway/latest/admin-api/#sni-object)
for all configuration options.

## Configure a Kong Gateway entity

1. From the left navigation menu in Konnect, open the ![runtimes icon](/assets/images/icons/konnect/icn-runtimes.svg){:.inline .konnect-icn .no-image-expand}
**Runtimes**.

2. Select an entity to configure from the menu, then click **+ Add {Entity Name}**.

4. Enter the entity configuration details.

    See the [Kong Admin API reference](/gateway/latest/admin-api) for all
    configuration field descriptions.

5. Click **Create**.

## Update or delete a Kong Gateway entity

1. Open the ![runtimes icon](/assets/images/icons/konnect/icn-runtimes.svg){:.inline .konnect-icn .no-image-expand}
**Runtimes**, then select an entity to configure from the menu.

2. Open the action menu on the right of a row, and click **Edit** or **Delete**.

    * If editing, adjust any values in the configuration, then click **Save**.
    * If deleting, confirm deletion in the dialog.


## Manage global or consumer-scoped plugins

Plugin configuration is slightly different from other {{site.base_gateway}} entities.
You can also enable or disable a plugin, which leaves the configuration intact
but lets you control whether the plugin is active or not.

### Configure a plugin

1. From the left navigation menu in Konnect, open the ![runtimes icon](/assets/images/icons/konnect/icn-runtimes.svg){:.inline .konnect-icn .no-image-expand}
**Runtimes**.

2. Select **Plugins** from the menu, then click **+ Install Plugin**.

3. Find and select the plugin of your choice.

3. Choose whether to make this plugin **Global** or **Scoped** to a consumer.

    For some plugins, there is only one option:
    * If that option is **Global**, you don't need to do anything else with it.
    * If the option is **Scoped**, select a consumer to scope it to.

4. Enter the plugin configuration details. These differ for every plugin.

    See the [Plugin Hub](/hub) for parameter descriptions.

5. Click **Create**.

### Disable or enable a plugin

Disable a global plugin from the Runtime Manager.

Disabling a plugin leaves its configuration intact, and you can re-enable the
plugin at any time.

1. Open the ![runtimes icon](/assets/images/icons/konnect/icn-runtimes.svg){:.inline .konnect-icn .no-image-expand}
**Runtimes**, then select **Plugins** from the menu.

2. Find your plugin in the plugins list and click the toggle in the **Enabled** column.

   If the plugin is applied to a Service or a Route, you can't change its
   settings from here. Click the tag in the **Applied To** column to go to the
   plugin's parent object, and update it there.
