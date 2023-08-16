---
title: Kong Gateway Configuration in Konnect
---

You can manage any {{site.base_gateway}} services, routes, certificates, consumer-scoped
configuration, and global configuration from within a runtime group.

A **global** object is a set of configurations that apply to, or can be used
by, all objects in a runtime group. For example, if you set up a Proxy Caching
plugin in the default runtime group and set it to `Global`,
the plugin configuration will apply to all services in the group.

Consumers, SNIs, upstreams, and certificates are all global. Plugins
can either be global or scoped.

{:.note}
> **Exceptions in composite runtime groups**: Some core entities have specific requirements and limitations 
when part of a composite runtime group. See the [Composite runtime groups](/konnect/runtime-manager/composite-runtime-groups/#configuring-core-entities) documentation for details.

### Gateway services

The **Gateway Service** configuration page lists all {{site.base_gateway}} services
in the runtime group. Service entities are abstractions of each of your own
upstream services, such as a data transformation microservice, or a billing API.

Gateway services can be managed though Runtime Manager:

* When you create a {{site.konnect_short_name}} service implementation through the Setup Wizard, it automatically creates a Gateway service.
* You can also create a Gateway service directly through Runtime Manager. This
service won't be attached to an API product by default.

To see if a Gateway service is connected to an API product, open its
detail page from {% konnect_icon runtimes %} **Runtime Manager** > **Gateway Services**. If it's attached to an
an API product you will see the name of the API product under **API Product**, and the API product version under **API product version**.

Learn more about [Gateway services in {{site.konnect_short_name}}](/konnect/runtime-manager/configuration/#gateway-services) or
check out the [service object API reference](/gateway/latest/admin-api/#service-object)
for all configuration options.

### Routes

The **Routes** configuration page lists all routes in the runtime group. A route defines rules to match client
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
[Service](/konnect/runtime-manager/enable-service-plugin) and
[route](/konnect/runtime-manager/enable-route-plugin) plugins must be managed
through the Runtime Manager.

Learn more about [using plugins in {{site.konnect_short_name}}](/konnect/runtime-manager/plugins/),
check out the [plugin object API reference](/gateway/latest/admin-api/#plugin-object),
or see all available plugins on the [Plugin Hub](/hub/) for specific configuration
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
A certificate object represents a public certificate and can be paired with a
corresponding private key. Certificates handle SSL/TLS termination for encrypted
requests, and can be used as a trusted CA store when validating the peer
certificate of a client or service.

Data plane certificates can be managed from the **Data plane certificates** dashboard that is available as a **Runtime group action**. Here you can manage data plane certificates, including the creation, renewal, and removal of certificates, as well as uploading up to 16 certificates per runtime group. 

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


### Vaults

You can use vaults to add authentication to a service or route with an access token and secret token. Credential tokens are stored securely using Vaults. Credential life-cyles can be managed through {{site.konnect_short_name}}. 

### Keys
With **Keys**, you can centrally store and easily access key sets and keys in {{site.konnect_short_name}}. A key set object holds a collection of asymmetrical key objects. You can group keys objects by purpose. A key object holds asymmetric keys in various formats. Key objects can be used when {{site.konnect_short_name}} or a {{site.konnect_short_name}} plugin requires a specific public or private key to perform an operation. You can create and manage key sets and key objects in {{site.konnect_short_name}}, from the **Runtime Manager** > **Keys** dashboard. Currently two key formats are supported:
* JWK
* PEM

To learn more about the details of this feature, reference the [{{site.base_gateway}} key reference documentation](/gateway/latest/reference/key-management/). The {{site.konnect_short_name}} keys feature is built using {{site.base_gateway}} ability to manage keys, the documentation available can serve as a reference for both {{site.base_gateway}} and {{site.konnect_short_name}}.

## Configuration limits

The following entity resource limits apply to each runtime group for the configuration:

| Resource name | Entity resource limit |
| --- | --- |
| Access Control List | 50,000 |
| Asymmetric Key | 1,000 |
| Asymmetric KeySet | 1,000 |
| Basic Authentication | 50,000 |
| Certificate Authority Certificate | 1,000 |
| Certificate | 1,000 |
| Consumer | 50,000 |
| Consumer Group | 1,000 |
| Consumer Group Rate Limiting Advanced Configuration | 1,000 |
| Custom Plugins | 100 |
| Data Plane Client Certificate | 32 |
| DeGraphQL Route | 1,000 |
| GraphQL Rate Limiting Cost Decoration | 1,000 |
| Hash-based Message Authentication | 50,000 |
| JSON Web Token | 50,000 |
| Key (API Key) Authentication | 50,000 |
| Mutual Transport Layer Security Authentication | 50,000 |
| Plugin Configuration | 10,000 |
| Route | 10,000 |
| Runtime Groups | 100 |
| Server Name Indication | 1,000 |
| Service | 10,000 |
| Target | 10,000 |
| Upstream | 10,000 |
| Vault | 1,000 |
