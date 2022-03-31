---
title: Shared Config
no_version: true
---

Use the ![icon](/assets/images/icons/konnect/konnect-shared-config.svg){:.inline .no-image-expand}
[**Shared Config** page](https://konnect.konghq.com/configuration/) in
{{site.konnect_saas}} to manage consumers,
upstreams, certificates, SNIs, and global and consumer-scoped plugins.

![Shared config overview](/assets/images/docs/konnect/konnect-shared-conf-overview.png)

**Consumers**
: Consumer objects represent users of a service, and are most often used for
authentication. They provide a way to divide access to your services, and
make it easy to revoke that access without disturbing a service's function.

: [Consumer object reference &gt;](/gateway/latest/admin-api/#consumer-object)

**Plugins**
: Plugins let you extend proxy functionality by adding rules, policies,
transformations, and more on requests and responses.

: You can manage global and consumer-scoped plugins from the Shared Config page, and
view all plugins in the cluster, including service and route plugins.

: Global plugins are plugins that apply to all services, routes, and consumers
in the cluster, as applicable, and consumer-scoped plugins only apply to a
specific consumer.

: [Configure global and consumer-scoped plugins &gt;](/konnect/legacy/manage-plugins/shared-config/)
: [Plugin object reference &gt;](/gateway/latest/admin-api/#plugin-object)
: [Plugin Hub &gt;](/hub/)

**Upstreams**
: An upstream object represents a virtual hostname referring to your own
service/API. Upstreams can be used to health
check, circuit break, and load balance incoming requests over multiple services
(targets).

: [Upstream object reference &gt;](/gateway/latest/admin-api/#upstream-object)

**Certificates**
: A certificate object represents a public certificate and can be paired with
a corresponding private key. Certificates handle SSL/TLS termination
for encrypted requests, and can be used as a trusted CA store when validating
the peer certificate of a client or service.

: [Certificate object reference &gt;](/gateway/latest/admin-api/#certificate-object)

**SNIs**
: An SNI object represents a many-to-one mapping of hostnames to a certificate.
A certificate object can have many hostnames associated with it, so when
{{site.base_gateway}} receives an SSL request, it uses the SNI field in the
ClientHello to look up the associated certificate object.

: [SNI object reference &gt;](/gateway/latest/admin-api/#sni-object)
