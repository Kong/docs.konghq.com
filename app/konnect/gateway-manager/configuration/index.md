---
title: Kong Gateway Configuration in Konnect
---

You can manage any {{site.base_gateway}} services, routes, certificates, consumer-scoped
configuration, and global configuration from within a control plane.

A **global** object is a set of configurations that apply to, or can be used
by, all objects in a control plane. For example, if you set up a Proxy Caching
plugin in the default control plane and set it to `Global`,
the plugin configuration will apply to all services in the control plane.

Consumers, SNIs, upstreams, and certificates are all global. Plugins
can either be global or scoped.

{:.note}
> **Exceptions in control plane groups**: Some core entities have specific requirements and limitations 
when part of a control plane group. See the [Control plane groups](/konnect/gateway-manager/control-plane-groups/#configuring-core-entities) documentation for details.

### Gateway services

The **Gateway Service** configuration page lists all {{site.base_gateway}} services
in the control plane. Service entities are abstractions of each of your own
upstream services, such as a data transformation microservice, or a billing API.

Gateway services can be managed though Gateway Manager:

* When you create a {{site.konnect_short_name}} service implementation through the Setup Wizard, it automatically creates a Gateway service.
* You can also create a Gateway service directly through Gateway Manager. This
service won't be attached to an API product by default.
* Services are geo-specific and are not shared between [geographic regions](/konnect/geo/).

To see if a Gateway service is connected to an API product, open its
detail page from {% konnect_icon runtimes %} **Gateway Manager** > **Gateway Services**. If it's attached to an
an API product you will see the name of the API product under **API Product**, and the API product version under **API product version**.

Learn more about [Gateway services in {{site.konnect_short_name}}](/konnect/gateway-manager/configuration/#gateway-services) or
check out the [service object API reference](/gateway/latest/admin-api/#service-object)
for all configuration options.

### Routes

The **Routes** configuration page lists all routes in the control plane. A route defines rules to match client
requests, and is associated with a Gateway service. You can edit any
routes in the control plane from here.

See the [route object API reference](/gateway/latest/admin-api/#route-object)
for all configuration options.

{:.important}
> **Important**: Starting with {{site.base_gateway}} 3.0.0.0, the router supports logical expressions.
Regex routes must begin with a `~` character. For example: `~/foo/bar/(?baz\w+)`.
Learn more in the [route configuration guide](/gateway/latest/key-concepts/routes/expressions/).

### Consumers

The **Consumers** configuration page lists all consumers in the control plane.
Consumer objects represent users of a service, and are most often used for
authentication. They provide a way to divide access to your services, and make
it easy to revoke that access without disturbing a service’s function.

See the [consumer object API reference](/gateway/latest/admin-api/#consumer-object)
for all configuration options.

### Plugins

The **Plugins** configuration page lists all plugins used by any
entities in the control plane. Plugins let you extend proxy functionality by
adding rules, policies, transformations, and more on requests and responses.

Although you can see all plugins from this page, you can only edit _global_ or
_consumer-scoped_ plugins through the Gateway Manager.
[Service](/konnect/gateway-manager/enable-service-plugin) and
[route](/konnect/gateway-manager/enable-route-plugin) plugins must be managed
through the Gateway Manager.

Learn more about [using plugins in {{site.konnect_short_name}}](/konnect/gateway-manager/plugins/),
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

Manage data plane certificates from their dashboard.
You can find the dashboard by opening the **Actions** menu of a control plane and 
selecting **Data Plane Certificates**.

Here you can manage data plane certificates, 
including the creation, renewal, and removal of certificates, as well as uploading up to 16 
certificates per control plane. 

See the [certificate object API reference](/gateway/latest/admin-api/#certificate-object)
for all configuration options.

### SNIs

The **SNIs** configuration page lists all SNIs configured in the control plane.

An SNI object represents a many-to-one mapping of hostnames to a certificate.
A certificate object can have many hostnames associated with it, so when a
data plane node receives an SSL request, it uses the SNI field in the
ClientHello to look up the associated certificate object.

See the [SNI object API reference](/gateway/latest/admin-api/#sni-object)
for all configuration options.


### Vaults

You can use vaults to add authentication to a service or route with an access token and secret token. Credential tokens are stored securely using Vaults. Credential life-cyles can be managed through {{site.konnect_short_name}}. 

### Keys
With **Keys**, you can centrally store and easily access key sets and keys in {{site.konnect_short_name}}. A key set object holds a collection of asymmetrical key objects. You can group keys objects by purpose. A key object holds asymmetric keys in various formats. Key objects can be used when {{site.konnect_short_name}} or a {{site.konnect_short_name}} plugin requires a specific public or private key to perform an operation. You can create and manage key sets and key objects in {{site.konnect_short_name}}, from the **Gateway Manager** > **Keys** dashboard. Currently two key formats are supported:
* JWK
* PEM

To learn more about the details of this feature, reference the [{{site.base_gateway}} key reference documentation](/gateway/latest/reference/key-management/). The {{site.konnect_short_name}} keys feature is built using {{site.base_gateway}} ability to manage keys, the documentation available can serve as a reference for both {{site.base_gateway}} and {{site.konnect_short_name}}.

## Configuration limits

The following entity resource limits apply to each control plane for the configuration:

| Resource name | Default Entity resource limit |
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
| Control Planes | 100 |
| Server Name Indication | 1,000 |
| Service | 10,000 |
| Target | 10,000 |
| Upstream | 10,000 |
| Vault | 1,000 |
