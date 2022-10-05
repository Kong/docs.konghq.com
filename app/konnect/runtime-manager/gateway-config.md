---
title: Kong Gateway Configuration in Konnect
no_version: true
---

You can manage any {{site.base_gateway}} services, routes, consumer-scoped
configuration, and global configuration from within a runtime group.

A **global** object is a set of configurations that apply to, or can be used
by, all objects in a runtime group. For example, if you set up a Proxy Caching
plugin in the default runtime group and set it to `Global`,
the plugin configuration will apply to all services in the group.

Consumers, SNIs, upstreams, and certificates are all global. Plugins
can either be global or scoped.

### Gateway services

The **Gateway Service** configuration page lists all {{site.base_gateway}} services
in the runtime group. Service entities are abstractions of each of your own
upstream services, such as a data transformation microservice, or a billing API.

Gateway services can be exposed in Service Hub, or managed though Runtime Manager
only:
* When you create a [{{site.konnect_short_name}} service implementation](/konnect/servicehub/service-implementations)
through the Service Hub, it automatically creates a Gateway service.
* You can also create a Gateway service directly through Runtime Manager. This
service won't be connected to any Service Hub implementation by default, unless you add a tag to link it.

To see if a Gateway service is connected to the Service Hub, open its
detail page from {% konnect_icon runtimes %} **Runtime Manager** > **Gateway Services**. If it's attached to an
implementation, you should see a tag in the following format: [`_KonnectService:{SERVICE_NAME}`](/deck/latest/guides/konnect/#konnect-service-tags).

Learn more about [services in {{site.konnect_short_name}}](/konnect/servicehub) or
check out the [service object API reference](/gateway/latest/admin-api/#service-object)
for all configuration options.

### Routes

The **Routes** configuration page lists all routes in the runtime group, including
routes created through the Service Hub. A route defines rules to match client
requests, and is associated with a Gateway service. You can edit any
routes in the runtime group from here.

See the [route object API reference](/gateway/latest/admin-api/#route-object)
for all configuration options.

{:.important}
> **Important**: Starting with {{site.base_gateway}} 3.0.0.0, the router supports logical expressions.
Regex routes must begin with a `~` character. For example: `~/foo/bar/(?baz\w+)`.
Learn more in the [route configuration guide](/gateway/latest/key-concepts/routes/expressions/).

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
[Service](/konnect/servicehub/enable-service-plugin) and
[route](/konnect/servicehub/enable-route-plugin) plugins must be managed
through the Service Hub.

Learn more about [using plugins in {{site.konnect_short_name}}](/konnect/servicehub/plugins),
check out the [plugin object API reference](/gateway/latest/admin-api/#plugin-object),
or see all available plugins on the [Plugin Hub](/hub) for specific configuration
options for each plugin.

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
[Renew Certificates](/konnect/runtime-manager/runtime-instances/renew-certificates).

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
